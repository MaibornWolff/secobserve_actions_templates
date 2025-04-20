from importer.secobserve_api import Api
from importer.environment import Environment
from requests.exceptions import HTTPError


def file_upload_sbom():
    try:
        environment = Environment()
        environment.check_environment_file_upload()
        api = Api()
        api.file_upload_sbom()
    except Exception as e:
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print(f"{e.__class__.__name__}: {str(e)}")
        if isinstance(e, HTTPError):
            print(f"Response: {e.response.content.decode('utf-8')}")
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        exit(1)


if __name__ == "__main__":
    file_upload_sbom()
