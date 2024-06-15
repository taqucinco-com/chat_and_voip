# -*- coding: utf-8 -*-
"""ChatGPT_API.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1fqbrHuDsISjzeIXwujp_FAkECDkcY9Lw
"""

# Commented out IPython magic to ensure Python compatibility.
# %pip install openai

from openai import OpenAI

# OPENAI_API_KEYの設定
OPENAI_API_KEY = "{your-openai-api-key}"

client = OpenAI(
    api_key=OPENAI_API_KEY,
)

def query_gpt(model, prompt, temperature=0.7, top_p=0.8, max_tokens=150, stop=""):
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "system", "content": "You are a helpful assistant."}, {"role": "user", "content": prompt}],
        temperature=temperature,
        max_tokens=max_tokens,
        top_p=top_p,
        stop=stop
    )

    return response.choices[0].message.content

# 使用例
response = query_gpt(
    model="gpt-3.5-turbo",
    prompt="今日の蟹座の、ラッキーアイテムを1つ教えてください。回答する時の語尾の「です」や「ます」に「ワン」を追加して「...ですワン」、「...ますワン」として犬っぽく答えてください。",
    temperature=1, # [0,2]で調整する
    # top_p=1, # (0,1]で調整する
    max_tokens=500
    )

response

# curl -X POST https://api.openai.com/v1/chat/completions \
# -H "Content-Type: application/json" \
# -H "Authorization: Bearer YOUR_TOKEN" \
# -d '{
#     "model": "gpt-3.5-turbo",
#     "messages": [
#         {"role": "system", "content": "You are a helpful assistant."},
#         {"role": "user", "content": "今日の蟹座の、ラッキーアイテムを1つ教えてください。回答する時の語尾の「です」や「ます」に「ワン」を追加して「...ですワ ン」、「...ますワン」として犬っぽく答えてください。"}
#     ],
#     "temperature": 1,
#     "max_tokens": 500 
# }'

