#!/bin/sh

####
# Locate files in /app/keys and attempt to decrypt them using stored
# IAM account details.
#
# Requires:
#    AWS_ACCESS_KEY_ID
#    AWS_SECRET_ACCESS_KEY
#    AWS_DEFAULT_REGION
####

if ls /app/keys/*.asc > /dev/null 2>&1 && [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    files=$(find /app/keys -name "*.asc")
    for file in $files; do
        decrypted_output=$(aws kms decrypt \
            --ciphertext-blob "fileb://${file}" \
            --output text \
            --query Plaintext 2> "${file%.asc}.error" | base64 --decode)

        if [ $? -eq 0 ]; then
            echo "Successfully decrypted $file"
            echo "${decrypted_output}" > "${file%.asc}"
        else
            decryption_error=$(<"${file%.asc}.error")
            echo "Error decrypting $file: $decryption_error"
        fi
        rm "${file%.asc}.error"
    done
fi