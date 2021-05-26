#include <stdlib.h>
#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include "sensirion_voc_algorithm.h"
#include "port_interface.h"

static VocAlgorithmParams voc_algorithm_params;

int main(int argc, char *argv[])
{
  char buffer[64];

  uint16_t sraw;
  int32_t voc_index;
  int32_t mean;
  int32_t std;
  int32_t voc_index_offset;
  int32_t learning_time_hours;
  int32_t gating_max_duration_minutes;
  int32_t std_initial;
  char nl;

  VocAlgorithm_init(&voc_algorithm_params);

  for (;;)
  {
    buffer[0] = '\0';

    // Command name length must be in 1..15
    if (scanf("%15s", buffer) == 0 || strlen(buffer) == 0)
    {
      if (feof(stdin))
      {
        debug("EOF");
        exit(EXIT_SUCCESS);
      }
      else
      {
        errx(EXIT_FAILURE, "read error");
      }
    }

    // Command "process 1"
    if (strcasecmp(buffer, "process") == 0)
    {
      if (scanf("%hu%c", &sraw, &nl) != 2 || nl != '\n')
      {
        reply_error("Argument error");
      }

      VocAlgorithm_process(&voc_algorithm_params, sraw, &voc_index);
      reply_ok_payload("%i", voc_index);
    }

    // Command "get_states"
    else if (strcasecmp(buffer, "get_states") == 0)
    {
      VocAlgorithm_get_states(&voc_algorithm_params, &mean, &std);
      reply_ok_payload("mean:%i,std:%i", mean, std);
    }

    // Command "set_states 1 2"
    else if (strcasecmp(buffer, "set_states") == 0)
    {
      if (scanf("%i %i%c", &mean, &std, &nl) != 3 || nl != '\n')
      {
        reply_error("Argument error");
      }

      VocAlgorithm_set_states(&voc_algorithm_params, mean, std);

      reply_ok_payload("mean:%i,std:%i", mean, std);
    }

    // Command "tuning_params 1 2 3 4"
    else if (strcasecmp(buffer, "tuning_params") == 0)
    {
      if (scanf("%i %i %i %i%c", &voc_index_offset, &learning_time_hours, &gating_max_duration_minutes, &std_initial, &nl) != 5 || nl != '\n')
      {
        reply_error("Argument error");
      }

      VocAlgorithm_set_tuning_parameters(&voc_algorithm_params,
                                         voc_index_offset,
                                         learning_time_hours,
                                         gating_max_duration_minutes,
                                         std_initial);

      reply_ok_payload(
          "voc_index_offset:%i,learning_time_hours:%i,gating_max_duration_minutes:%i,std_initial:%i",
          voc_index_offset,
          learning_time_hours,
          gating_max_duration_minutes,
          std_initial);
    }
    // "hello"
    else if (strcasecmp(buffer, "hello") == 0)
    {
      reply_ok();
    }
    else
    {
      reply_error("Unrecognized command: '%s'", buffer);
    }
  }
}
