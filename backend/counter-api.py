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

    # handling of incorrect HTTP methods
    if event['httpMethod'] != 'POST':
        return {
            'statusCode': 405,
            'headers': headers,
            'body': json.dumps({'error': f'Method {event['httpMethod']} not allowed. Use POST instead.'})
        }

    try:
        # parse body
        try:
            body = json.loads(event['body']) if event.get('body') else {} # if body is empty or None, return {} instead of parsing
        except (TypeError, json.JSONDecodeError):
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Invalid JSON format'})
						}

        # get current item
        current_item = table.get_item(Key={'id': 'visitor'})

        # check if item exists in database, if not - initialize it
        if 'Item' not in current_item:
            response = table.put_item(
                Item = {
                    'id': 'visitor',
                    'count': 0
                }
            )
            current_count = 0
            
        # item exists
        else:
          current_count = int(current_item.get('Item', {}).get('count', 0))

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

        # validation if the count was actually incremented
        if updated_count <= current_count:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'error': 'Database update failed. Count did not increase.'})
            }
        
        # count was correctly incremented
        return {
            'statusCode': statusCode,
            'headers': headers,
            'body': json.dumps({'message': 'Counter updated', 'count': updated_count, 'previous_count': current_count})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }


