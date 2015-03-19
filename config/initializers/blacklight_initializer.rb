# A secret token used to encrypt user_id's in the Bookmarks#export callback URL
# functionality, for example in Refworks export of Bookmarks. In Rails 4, Blacklight
# will use the application's secret key base instead.
#

# Blacklight.secret_key = 'efb70c08c4668f9077b26e5703e168db03c67b2348af538649bd5ed294f1f3b6141942c9e90ac5d66e6ac3dbf08371b4b21ab0809dfe626bf24f7e60ec724992'
Blacklight.secret_key = ENV["SCHOLARSARCHIVE_BLACKLIGHT_SECRET"] || 'DSAFpnasd98fbIADSfndsfpiasdhfiasbdfZBiasdf8a8Zk'
