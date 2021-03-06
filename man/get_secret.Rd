% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/secrets.R
\name{get_secret}
\alias{get_secret}
\title{Retrieve a secret from the vault.}
\usage{
get_secret(name, key = local_key(), vault = NULL)
}
\arguments{
\item{name}{Name of the secret.}

\item{key}{The private RSA key to use. It defaults to the current
user's default key.}

\item{vault}{Vault location (starting point to find the vault).
To create a vault, use \code{\link[=create_vault]{create_vault()}} or \code{\link[=create_package_vault]{create_package_vault()}}.
If this is \code{NULL}, then \code{secret} tries to find the vault automatically:
\itemize{
\item If the \code{secret.vault} option is set to path, that is used as the
starting point.
\item Otherwise, if the \code{R_SECRET_VAULT} environment variable is set to a
path, that is used as a starting point.
\item Otherwise the current working directory is used as the starting
point.
}

If the starting point is a vault, that is used. Otherwise, if the
starting point is in a package tree, the \code{inst/vault} folder is used
within the package. If no vault can be found, an error is thrown.}
}
\description{
Retrieve a secret from the vault.
}
\examples{

# The `secret` package contains some user keys for demonstration purposes.
# In this example, Alice shares a secret with Bob using a vault.

keys <- function(x){
  file.path(system.file("user_keys", package = "secret"), x)
}
alice_public  <- keys("alice.pub")
alice_private <- keys("alice.pem")
bob_public  <- keys("bob.pub")
bob_private <- keys("bob.pem")
carl_private <- keys("carl.pem")

# Create vault

vault <- file.path(tempdir(), ".vault")
if (dir.exists(vault)) unlink(vault) # ensure vault is empty
create_vault(vault)

# Add users with their public keys

add_user("alice", public_key = alice_public, vault = vault)
add_user("bob", public_key = bob_public, vault = vault)
list_users(vault = vault)

# Share a secret

secret <- list(username = "user123", password = "Secret123!")

add_secret("secret", value = secret, users = c("alice", "bob"),
           vault = vault)
list_secrets(vault = vault)

# Alice and Bob can decrypt the secret with their private keys
# Note that you would not normally have access to the private key
# of any of your collaborators!

get_secret("secret", key = alice_private, vault = vault)
get_secret("secret", key = bob_private, vault = vault)

# But Carl can't decrypt the secret

try(
  get_secret("secret", key = carl_private, vault = vault)
)

# Unshare the secret

unshare_secret("secret", users = "bob", vault = vault)
try(
  get_secret("secret", key = bob_private, vault = vault)
)


# Delete the secret

delete_secret("secret", vault = vault)
list_secrets(vault)

# Delete the users

delete_user("alice", vault = vault)
delete_user("bob", vault = vault)
list_users(vault)
}
\seealso{
Other secret functions: \code{\link{add_secret}},
  \code{\link{delete_secret}}, \code{\link{list_owners}},
  \code{\link{list_secrets}}, \code{\link{local_key}},
  \code{\link{share_secret}}, \code{\link{unshare_secret}},
  \code{\link{update_secret}}
}
