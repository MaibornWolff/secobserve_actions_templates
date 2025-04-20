import os


class Environment:
    def __init__(self):
        self.api_base_url = os.getenv("SO_API_BASE_URL")
        self.api_token = os.getenv("SO_API_TOKEN")
        self.product_name = os.getenv("SO_PRODUCT_NAME")
        self.branch_name = os.getenv("SO_BRANCH_NAME", None)
        self.file_name = os.getenv("SO_FILE_NAME", None)
        self.parser_name = os.getenv("SO_PARSER_NAME", None)
        self.api_configuration_name = os.getenv("SO_API_CONFIGURATION_NAME", None)
        self.service = os.getenv("SO_ORIGIN_SERVICE", None)
        self.docker_image_name_tag = os.getenv("SO_ORIGIN_DOCKER_IMAGE_NAME_TAG", None)
        self.endpoint_url = os.getenv("SO_ORIGIN_ENDPOINT_URL", None)
        self.suppress_licenses = os.getenv("SO_SUPPRESS_LICENSES", None)

    def check_environment_file_upload(self):
        error_string = self.check_environment_common()
        if self.file_name is None:
            if error_string != "":
                error_string = error_string + " / "
            error_string = error_string + "SO_FILE_NAME is missing"

        if len(error_string) > 0:
            raise Exception(error_string)

        print("SecObserve Upload")
        print("- SO_API_BASE_URL:                 ", self.api_base_url)
        print("- SO_PRODUCT_NAME:                 ", self.product_name)
        if self.branch_name:
            print("- SO_BRANCH_NAME:                  ", self.branch_name)
        print("- SO_FILE_NAME:                    ", self.file_name)
        if self.parser_name:
            print("- SO_PARSER_NAME:                  ", self.parser_name)
        if self.service:
            print("- SO_ORIGIN_SERVICE:               ", self.service)
        if self.docker_image_name_tag:
            print("- SO_ORIGIN_DOCKER_IMAGE_NAME_TAG: ", self.docker_image_name_tag)
        if self.endpoint_url:
            print("- SO_ORIGIN_ENDPOINT_URL:          ", self.endpoint_url)
        if self.suppress_licenses is not None:
            print("- SO_SUPPRESS_LICENSES:            ", self.suppress_licenses)
        print("")

    def check_environment_common(self):
        error_string = ""
        if self.api_base_url is None:
            error_string = "SO_API_BASE_URL is missing"
        if self.api_token is None:
            if error_string != "":
                error_string = error_string + " / "
            error_string = error_string + "SO_API_TOKEN is missing"
        if self.product_name is None:
            if error_string != "":
                error_string = error_string + " / "
            error_string = error_string + "SO_PRODUCT_NAME is missing"

        return error_string
