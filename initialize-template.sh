#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

git config --global user.name "CI"
git config --global user.email "ci@ci.com"

git_json="{\"git\":{\"owner\":\"${owner_name}\",\"name\":\"${project_name}\"}}"
echo "GIT JSON:"
echo "${git_json}"
echo

# This codeblock answers the prompts issued by battenberg below.
{
    # You've downloaded .../.cookiecutters/template-java-kotlin-library before.
    # Is it okay to delete and re-download it? [yes]:
    echo "1";
    sleep 1;

    # owner [Product Infrastructure]:
    echo "Product Infrastructure";
    sleep 1;

    # component_id []:
    echo "${project_name}"
    sleep 1;

    # artifact_id [java-kotlin-lib-test-*****]:
    echo
    sleep 1;

    # storePath [https://github.com/fp-mt-test-org/java-kotlin-lib-test-*****]:
    echo
    sleep 1;

    # java_package_name [javakotlinlibtest*****]:
    echo
    sleep 1;

    # description [*****]:
    echo "This project was created from the ${template_name} template."
    sleep 1;

    # destination [default]:
    echo "${git_json}"
    sleep 1;
} | battenberg install "${github_base_url}/${template_name}" || true

cat .cookiecutter.json
