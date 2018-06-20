#
# @example
#   include users
#
#   users::virtual:
#     user1:
#       comment: Test user1
#       tag: tag1
#       ssh_authorized_keys:
#         -
#           key: AAAAB3Nza[...]qXfdaQ==
#           type: ssh-rsa
#
#   users::realized:
#     - user1
#
# @param virtual
# @param realized
class users(
  Hash             $virtual,
  Array[String[1]] $realized,
) {
  $virtual.each |$user_name, $user_opts| {
    @Users::User { $user_name:
      * => $user_opts,
    }
  }

  $realized.each |$value| {
    Users::User <| name == $value or tag == $value |>
  }
}
