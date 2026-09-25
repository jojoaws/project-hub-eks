import os
import uuid

import boto3


s3_client = boto3.client(
    "s3",
    region_name=os.getenv("AWS_REGION")
)

BUCKET_NAME = os.getenv(
    "S3_BUCKET_NAME"
)

def generate_presigned_url(
    key: str
) -> str:

    return s3_client.generate_presigned_url(
        "get_object",
        Params={
            "Bucket": BUCKET_NAME,
            "Key": key
        },
        ExpiresIn=3600
    )

def upload_file(
    file,
    folder: str
) -> str:

    extension = file.filename.split(".")[-1]

    key = (
        f"{folder}/"
        f"{uuid.uuid4()}.{extension}"
    )

    s3_client.upload_fileobj(
        file.file,
        BUCKET_NAME,
        key
    )

    return key
