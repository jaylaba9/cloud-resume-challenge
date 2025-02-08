import json
import boto3

# dynamodb initialization
client = boto3.client('dynamodb')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('crc-website-visitor-counter')

def lambda_handler(event, context):
    statusCode = 200
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*' # CORS for frontend
    }
    try:
        # update visitor counter in dynamodb table
        response = table.update_item(
            Key = {
                'id': 'visitor'
            },
            UpdateExpression = 'ADD #c :num', # alternative - 'set #c = #c + :num'
            ExpressionAttributeNames = {
                '#c': 'count'
            },
            ExpressionAttributeValues = {
                ':num': 1
            },
            ReturnValues = 'UPDATED_NEW'
        )
        # get updated visitor counter from dynamodb table and conversion Decimal -> int
        updated_count = int(response.get('Attributes', {}).get('count', 0)) # get Attributes, if not found return {} -> get count, if not found, return 0

        return {
            'statusCode': statusCode,
            'headers': headers,
            'body': json.dumps({'message': 'Counter updated', 'count': updated_count})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }


