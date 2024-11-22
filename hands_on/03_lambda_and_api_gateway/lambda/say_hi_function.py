def handler(event, context):
    response = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": "Hai, i am heidi from swiss",
    }
    return response
