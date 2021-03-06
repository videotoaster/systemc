#!/usr/bin/env bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
set -e
TEST_DESCRIPTION="test systemd-dissect"
IMAGE_NAME="dissect"
TEST_NO_NSPAWN=1

. $TEST_BASE_DIR/test-functions

command -v mksquashfs >/dev/null 2>&1 || exit 0
command -v veritysetup >/dev/null 2>&1 || exit 0

# Need loop devices for systemd-dissect
test_create_image() {
    create_empty_image_rootdir

    # Create what will eventually be our root filesystem onto an overlay
    # If some pieces are missing from the host, skip rather than fail
    (
        LOG_LEVEL=5
        setup_basic_environment
        mask_supporting_services

        instmods loop =block
        instmods squashfs =squashfs
        instmods dm_verity =md
        generate_module_dependencies
        inst_binary mksquashfs
        inst_binary veritysetup
    )
}

do_test "$@" 50
