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

# The "|| true" above is to prevent this script from failing
# in the event that initialize-template.sh fails due to errors,
# such as merge conflicts.

echo
echo "Checking for MergeConflictExceptions..."
echo
if [[ "${battenberg_output}" =~ "MergeConflictException" ]]; then
    template_context_file='.cookiecutter.json'
    echo "Merge Conflict Detected, attempting to resolve!"

    # Remove all instances of:
    # <<<<<<< HEAD
    # ...
    # =======
    
    # And

    # Remove all instances of:
    # >>>>>>> 0000000000000000000000000000000000000000
    
    cookiecutter_json_updated=$(cat ${template_context_file} | \
        perl -0pe 's/<<<<<<< HEAD[\s\S]+?=======//gms' | \
        perl -0pe 's/>>>>>>> [a-z0-9]{40}//gms')

    echo "${cookiecutter_json_updated}" > "${template_context_file}"
    echo
    echo "Conflicts resolved, committing..."
    git add "${template_context_file}"
    git commit -m "fix: Resolved merge conflicts with template."
else
    echo "No merge conflicts detected."
    exit 1
fi

echo
cat .cookiecutter.json
