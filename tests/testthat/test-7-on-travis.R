
context("Sharing a secret with Travis")

test_that("Can read secret from vault", {

  if (Sys.getenv("TRAVIS", "") == "") skip("Only on Travis")

  expect_equal(
    get_secret("hidden", key = openssl::read_key("~/.ssh/id_rsa")),
    "This is a secret!"
  )
})
