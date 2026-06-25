import datetime


def lambda_handler(event, context):
    return int(datetime.datetime.now().strftime("%s")) * 1000
