#include <stdio.h>
#include "tdx_attest.h"


int main(int argc, char *argv[])
{
    uint32_t quote_size = 0;
    tdx_report_data_t report_data = {{0}};
    tdx_report_t tdx_report = {{0}};
    tdx_uuid_t selected_att_key_id = {0};
    uint8_t *p_quote_buf = NULL;
    tdx_rtmr_event_t rtmr_event = {0};

    if (fread(report_data.d, sizeof(report_data.d), 1, stdin) != 1) {
        fprintf(stderr, "Failed to read report data from stdin\n");
        return 1;
    }

    if (TDX_ATTEST_SUCCESS != tdx_att_get_report(&report_data, &tdx_report)) {
        fprintf(stderr, "\nFailed to get the report\n");
        return 1;
    }

    if (TDX_ATTEST_SUCCESS != tdx_att_get_quote(&report_data, NULL, 0, &selected_att_key_id,
        &p_quote_buf, &quote_size, 0)) {
        fprintf(stderr, "\nFailed to get the quote\n");
        return 1;
    }

    if (fwrite(p_quote_buf, quote_size, 1, stdout) != 1) {
        fprintf(stderr, "\nFailed to write quote to stdout\n");
        tdx_att_free_quote(p_quote_buf);
        return 1;
    }

    tdx_att_free_quote(p_quote_buf);
    return 0;
}
