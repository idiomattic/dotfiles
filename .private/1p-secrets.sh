# For GPR access
export GITHUB_USERNAME="{{ op://Employee/GitHub/login }}"
export GITHUB_TOKEN="{{ op://Employee/GitHub/token }}"
export GITHUB_PASSWORD="{{ op://Employee/GitHub/token }}"
# For Clojars publishing
export CLOJARS_USERNAME="{{ op://Employee/Clojars/username }}"
export CLOJARS_PASSWORD="{{ op://Employee/Clojars/Saved on clojars.org/Token }}"

# For GH CLI
export GH_TOKEN="{{ op://Employee/GitHub/password }}"

# NPM
export NPM_TOKEN="{{ op://Employee/5wwxlemqpc45d5xc3uppztms7y/password }}"

# Misc secrets
export SEARCH_VIS_API_KEY_PROD="{{ op://Employee/SEARCH_VIS_API_KEY_PROD/password }}"
export SEARCH_VIS_API_KEY="{{ op://Employee/SEARCH_VIS_API_KEY/password }}"
export SEARCH_RANK_MAC_CHEESE_VARIANT="{{ op://Employee/SEARCH_RANK_MAC_CHEESE_VARIANT/password }}"
export SEARCH_RANK_LASAGNA_VARIANT="{{ op://Employee/SEARCH_RANK_LASAGNA_VARIANT/password }}"
export SEARCH_ILB_IP="{{ op://Employee/SEARCH_ILB_IP/URL }}"
export SEARCH_ILB_IP_DATA_ES="{{ op://Employee/SEARCH_ILB_IP_DATA_ES/URL }}"
export SEARCH_METRICS_BY_LISTING_KEYWORD="{{ op://Employee/SEARCH_METRICS_BY_LISTING_KEYWORD/URL }}"
export KEYWORD_TAXONOMY="{{ op://Employee/KEYWORD_TAXONOMY/URL }}"
export LISTING_METRICS="{{ op://Employee/LISTING_METRICS/URL }}"
export COHERE_API_KEY="{{ op://Employee/COHERE_API_KEY/credential }}"

# Control var
export SECRETS_LOADED=true
