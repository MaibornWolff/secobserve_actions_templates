# SecObserve GitHub actions and GitLab CI templates

SecObserve gathers results about potential security flaws from various vulnerability scanning tools and makes them available for assessment and reporting.

It consists of 2 major components:

* **GitHub actions and GitLab CI templates:** Integrating vulnerability scanners into a CI/CD pipeline can be tedious. Each tool has to be installed differently and is called with different parameters. To avoid having to solve this task all over again, there are repositories with GitHub actions and GitLab CI templates. These make the process of integrating vulnerability scanners very simple by providing uniform methods for launching the tools and uniform parameters. The tools are regularly updated in the repositories so that the latest features and bug fixes are always available.

  All actions and templates run the scanner, upload the results into SecObserve and make the results of the scans available for download as artefacts in JSON format.

  These GitHub actions and GitLab CI templates are the content of this repository.

* **Vulnerability management system SecObserve:** SecObserve provides the development team with an overview of the results of all vulnerability scans for their project, which can be easily filtered and sorted. In the detailed view, the results are displayed uniformly with a wealth of information, regardless of which vulnerability scanner generated them.

  The sources of the vulnerability management system can be found in [https://github.com/MaibornWolff/SecObserve](https://github.com/MaibornWolff/SecObserve).

## Available actions and templates

| Scanner | GitHub Action | GitLab CI Template | License |
|----------|---------|-------------|--------|
| [Bandit](https://bandit.readthedocs.io/en/latest)                 | `actions/SAST/bandit` | `templates/SAST/bandit.yml` | [Apache 2.0](https://github.com/PyCQA/bandit/blob/main/LICENSE) |
| [ESLint](https://github.com/eslint/eslint)                        | `actions/SAST/eslint` | `templates/SAST/eslint.yml` | [MIT](https://github.com/eslint/eslint/blob/main/LICENSE) |
| [Semgrep](https://semgrep.dev/docs)                               | `actions/SAST/semgrep` | `templates/SAST/semgrep.yml` |[LGPL 2.1](https://github.com/returntocorp/semgrep/blob/develop/LICENSE) |
| [Checkov](https://www.checkov.io/1.Welcome/Quick%20Start.html)    | `actions/SAST/checkov` | `templates/SAST/checkov.yml` | [Apache 2.0](https://github.com/bridgecrewio/checkov/blob/main/LICENSE) |
| [KICS](https://docs.kics.io/latest)                               | `actions/SAST/kics` | `templates/SAST/kics.yml` | [Apache 2.0](https://github.com/Checkmarx/kics/blob/master/LICENSE) |
| [Grype](https://github.com/anchore/grype)                         | `actions/SCA/grype_image` | `templates/SCA/grype_image.yml` | [Apache 2.0](https://github.com/anchore/grype/blob/main/LICENSE) |
| [Trivy](https://aquasecurity.github.io/trivy)                     | `actions/SCA/trivy_filesystem` | `templates/SCA/trivy_filesystem.yml` | [Apache 2.0](https://github.com/aquasecurity/trivy/blob/main/LICENSE) |
| [Trivy](https://aquasecurity.github.io/trivy)                     | `actions/SCA/trivy_image` | `templates/SCA/trivy_image.yml` | [Apache 2.0](https://github.com/aquasecurity/trivy/blob/main/LICENSE) |
| [Gitleaks](https://gitleaks.io)                                   | `actions/secrets/gitleaks` | `templates/secrets/gitleaks.yml` | [MIT](https://github.com/gitleaks/gitleaks/blob/master/LICENSE) |
| [CryptoLyzer](https://gitlab.com/coroner/cryptolyzer)             | `actions/DAST/cryptolyzer` | `templates/DAST/cryptolyzer.yml` | [MPL 2.0](https://gitlab.com/coroner/cryptolyzer/-/blob/master/LICENSE.txt) |
| [DrHeader](https://github.com/Santandersecurityresearch/DrHeader) | `actions/DAST/drheader` | `templates/DAST/drheader.yml` | [MIT](https://github.com/Santandersecurityresearch/DrHeader/blob/master/LICENSE) |
| [OWASP ZAP](https://github.com/zaproxy/zaproxy)                   | `actions/DAST/owasp_zap` | `templates/DAST/owasp_zap.yml` | [Apache 2.0](https://github.com/zaproxy/zaproxy/blob/main/LICENSE) |

All GitHub actions and GitLab CI templates use a pre-built Docker image that contains all scanners and the SecObserve importer.

## Documentation

See [GitHub actions and GitLab CI templates](https://maibornwolff.github.io/SecObserve/integrations/github_actions_and_templates) for the full documentation how to use the actions and templates.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

SecObserve is licensed under the [3-Clause BSD License](LICENSE.txt)
