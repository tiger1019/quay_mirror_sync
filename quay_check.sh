qs_api_token=
quay_source=
qt_api_token=
quay_target=
quay_org=

images_repo=$(curl -sk -X GET -H "Authorization: Bearer ${qs_api_token}" https://${quay_source}/api/v1/repository?namespace=${quay_org} | jq -r -c '.repositories[].name')

for images in ${images_repo};
do
  image_manifest=$(curl -sk -X GET -H "Authorization: Bearer ${qs_api_token}" https://${quay_source}/api/v1/repository/${quay_org}/${images}/tag/ | jq -r -c '.tags[].manifest_digest');
  for manifest in ${image_manifest};
  do
    image_staus=$(curl -sk -X GET -H "Authorization: Bearer ${qt_api_token}" https://${quay_target}/api/v1/repository/${quay_org}/${images}/manifest/${manifest}| jq .error_message)
    
    if [ ${image_staus}=="null" ]; then
      continue;
    else
      echo "${quay_org}/${images}@${manifest} is not found"
    fi 
  done
done
