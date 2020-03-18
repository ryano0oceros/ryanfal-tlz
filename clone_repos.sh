#!/bin/bash

TLZDEMO_TOKEN=38377742d6669dca81f84dee304f83520e8861cb
TLZORG="tlzproject"
TLZREPOS="core-logging \
          terraform-aws-vpc \
          terraform-aws-baseline-common \
          terraform-aws-avm \
          sandbox-account \
          core-shared-services \
          core-network \
          core-security \
          core-bootstrap-master-payer \
          core-s3-backend-state-bucket \
          core-master-payer \
          core-account-request-form \
          core-avm \
          core-bootstrap-shared-services \
          application-account \
          terraform-aws-ip_whitelist \
          sandbox-resources \
          application-resources \
          terraform-null-label"

echo "Creating workshop workspace in ~/Documents/git/tlz/..."
mkdir -p ~/tlzworkshop
cd ~/Documents/git/tlz

for repo in $TLZREPOS; do
  GITHUB_TOKEN=$TLZDEMO_TOKEN hub clone $TLZORG/$repo
  pushd $repo

  echo "Replace org in module sources"
  find . -type f -name "*.tf" -print0 | xargs -0 sed -i '' -e "s/tlzproject/$GITHUB_ORG/g"

  echo "Commit changes"
  git add .
  git commit -m "Replacing tlzproject in module source with $GITHUB_ORG"

  echo "Creating repo in your GitHub Org $GITHUB_ORG"
  HUB_PROTOCOL=ssh hub create --private --remote-name=tlzworkshop

  echo "Push changes to tlzworkshop remote at $GITHUB_ORG/$repo"
  git push tlzworkshop

  popd
  echo
  echo
done
