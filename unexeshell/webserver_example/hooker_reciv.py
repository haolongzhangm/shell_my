from flask import Flask, request  
  
app = Flask(__name__)  
  
@app.route('/', methods=['POST'])
def webhook():  
    data = request.json  
    # data is dict from gitlab webhook json, now loop print key and value
    #for key, value in data.items():
    #    print(f'----:{key}:{value}')
    # try get msg and url from data
    try:
        object_attributes = data['object_attributes']
        description = object_attributes['description']
        url = object_attributes['url']
        print(f'----:msg:{description}')
        print(f'----:url:{url}')
        # now send msg to dingding
        import requests
        import json
        webhook = 'https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        headers = {'Content-Type': 'application/json;charset=utf-8'}
        data = {
            "msgtype": "text",
            "text": {
                "content": description + '\n' + url
            },
            at = {
                "at": {
                    "atMobiles": [
                        "xxxxxxxxxxx"
                    ],
                    "isAtAll": False
                }
            }
        }
        r = requests.post(webhook, headers=headers, data=json.dumps(data))
        return r



    except Exception as e:
        print(f'not a care event, {e}, skip it')
        return 'OK'
    
    return 'OK'  
  
if __name__ == '__main__':  
    app.run(host="xxx.xxx.xxxx.xxx", port=9999)
