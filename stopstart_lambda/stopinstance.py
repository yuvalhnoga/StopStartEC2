import boto3
import pprint

def lambda_handler(event, context):
    region = "eu-west-1"
    ec2 = boto3.client('ec2', region_name=region)
    instanceIDS = ec2.describe_instances(Filters=[{'Name': 'tag:Env', 'Values': ['Lab-1']}])

    for instanceID in instanceIDS['Reservations']:
        instance = instanceID['Instances'][0]['InstanceId']
        pprint.pprint(ec2.stop_instances(InstanceIds=[instance]))