# It uses virtual and realized resources Users::User. All users parameters
# should be defined for all nodes in the hash users::virtual. Required users
# should be listed in the array users::realized for a node.
#
# @summary This class manages users and their SSH authorized keys.
#
# @example
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
#   All users parameters.
# @param realized
#   List of users or tags to be realized.
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
