import boto3
import botocore
import os


def lambda_handler(event, context):
    print(f"Hello Github Actions from Lambda! Run in env: {os.environ['APP_ENV']}")
    print(f"boto3 version: {boto3.__version__}")
    print(f"botocore version: {botocore.__version__}")
    print(f"event: {event}")
