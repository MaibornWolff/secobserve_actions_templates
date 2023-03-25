from importer.secobserve_api import Api
from importer.environment import Environment


def file_upload_observations():
    try:
        environment = Environment()
        environment.check_environment_file_upload()
        api = Api()
        api.file_upload_observations()
    except Exception as e:
        print(f"{e.__class__.__name__}: {str(e)}")
        exit(1)


if __name__ == "__main__":
    file_upload_observations()
