## Check CIRP and AP files have not been changed
context("CIRP + AP")
library(tools)

chk <- md5sum("../../data/homa76.RData")
test_that("homa76 CIRP is unchanged.", {
    expect_match(chk, "a27463f33dd423413508354c89d13d01")
})

chk <- md5sum("../../data/krus96.RData")
test_that("krus96 AP is unchanged.", {
    expect_match(chk, "f7dff35adc2482df21ffba48bcc5671e")
})

chk <- md5sum("../../data/nosof88.RData")
test_that("nosof88 CIRP is unchanged.", {
    expect_match(chk, "f55b24fe059cb2df43a4f79f71a5c9a7")
})

chk <- md5sum("../../data/nosof94.RData")
test_that("nosof94 CIRP is unchanged.", {
    expect_match(chk, "9702b5ae68164bc9bb76cf1a8f289bf4")
})

chk <- md5sum("../../data/shin92.RData")
test_that("shin92 CIRP is unchanged.", {
    expect_match(chk, "80a632e94eb9c18fbd347e308dc2ecd8")
})


