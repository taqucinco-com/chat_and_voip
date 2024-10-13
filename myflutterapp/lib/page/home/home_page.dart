import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/component/chat_tile.dart';
import 'package:myflutterapp/driver/http/client_channel_establisher_provider.dart';
import 'package:myflutterapp/feature/advertise/admob/use_interstitial_ad.dart';
import 'package:myflutterapp/feature/advertise/advertiser_provider.dart';
import 'package:myflutterapp/feature/aidog/aidog_provider.dart';
import 'package:myflutterapp/feature/auth/auth_provider.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/domain/message_object.dart';
import 'package:myflutterapp/feature/message/usecase/message_store.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase_provider.dart';
import 'package:myflutterapp/page/home/components/message_bar.dart';
import 'package:myflutterapp/src/generated/aidog.pbgrpc.dart';
import 'package:uuid/uuid.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final useCase = ref.watch(messageUseCaseProvider);
    final messages = ref.watch(messagesProvider);
    final myMessageNotifier = ref.read(myMessagesProvider.notifier);
    final aiMessageNotifier = ref.read(aiMessagesProvider.notifier);
    final isSending = useState(false);

    final ask = ref.read(aiDogAskProvider);
    final establish = ref.read(clientChannelEstablisherProvider);
    // final myMessages = useState<List<(DateTime date, String word)>>([]);
    // final dogMessages = useState<List<(DateTime date, String word)>>([]);

    final scrollController = useScrollController();

    final advertiser = ref.watch(advertiserProvider);
    final interstitialAd = useFutureInterstitialAd(advertiser);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (messages.isNotEmpty) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
      return null;
    }, [messages]);

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return const Text("Error");
    };
    FlutterError.onError = (details) {
      if (kDebugMode) print(details);
    };

    final messageList = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => primaryFocus?.unfocus(),
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: messages.length + (isSending.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (isSending.value && index >= messages.length) {
              return ChatTile(message: (DateTime.now(), '...'), isMine: false);
            }
            final message = messages[index];
            final isMine = message is MyMessageEntity;
            return ChatTile(
                message: (message.createdAt, message.text), isMine: isMine);
          },
        ),
      ),
    );

    final chatView = Column(
      children: [
        const SizedBox(height: 16.0),
        Expanded(child: messageList),
        MessageBar(
          onSubmit: (text) async {
            // final result = await advertiser
            //     .sendTriggerEvent(AdvertiseTriggerEventQuestion());
            // if (result) {
            //   if (interstitialAd.data != null) {
            //     interstitialAd.data!.show();
            //   }
            // }
            primaryFocus?.unfocus();
            final entity = MyMessageObject(
              id: const Uuid().v4(),
              text: text,
              createdAt: DateTime.now(),
              status: MessageStatus.sending,
            );

            myMessageNotifier.add([entity]);
            try {
              isSending.value = true;
              // await for (final progress in useCase.send(text)) {
              //   print(progress);
              // }

              final uuid = const Uuid().v4();
              await for (final answer in test(text)) {
                isSending.value = false;

                if (ref.read(messagesProvider).any((v) => v.id == uuid)) {
                  aiMessageNotifier.appendTextWithId(uuid, answer);
                } else {
                  final newMessage = AiMessageObject(
                    id: uuid,
                    text: answer,
                    createdAt: DateTime.now(),
                  );
                  aiMessageNotifier.add([newMessage]);
                }
              }
            } finally {
              isSending.value = false;
            }
          },
        ),
      ],
    );

    final loginView = Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "このアプリでAI犬から教えてもらうにはログインが必要です。",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/settings');
                },
                child: const Text("設定に移動する"),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: switch (authState) {
        AsyncError(:final error) => Text("Error: $error"),
        AsyncData(:final value) => value != null ? chatView : loginView,
        _ => const CircularProgressIndicator(),
      },
    );
  }
}

Stream<String> test(String question) async* {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = AidogClient(channel);

  try {
    final request = DifyRequest();
    request.question = question;
    request.name = "Sudo";
    request.conversationId = "";
    await for (var response in stub.sendQuestion(request)) {
      print("Received: $response");
      yield response.answer;
    }
  } catch (e) {
    print('Caught error: $e');
  } finally {
    await channel.shutdown();
  }
}
