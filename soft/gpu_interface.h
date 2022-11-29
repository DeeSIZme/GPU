#ifndef GPU_INTERFACE_H_
#define GPU_INTERFACE_H_

#include <stdint.h>

typedef struct {
  int16_t d[3];
  int16_t reserved;
} pos_t;

typedef struct {
  uint8_t rgb[3];
  uint8_t reserved;
} color_t;

typedef struct {
  uint32_t count;

  // aligned on 32 bit
  pos_t* pos;

  // aligned on 32 bit
  color_t* color;

  int16_t transform_matrix[16];

} vertex_array_t;

#define VERTEX_BUFFER_INIT(name, length) \
  pos_t pos_##name[length];              \
  color_t color_##name[length];          \
  vertex_buffer_t##name = {              \
    .count = length,                   \
    .pos = pos_##name,                 \
    .color = color_##name,             \
  }

VERTEX_BUFFER_INIT(test, 10);

#define GPU_OPCODE_DRAW
#define GPU_OPCODE_CLEAR

#include "vertex_buffer.h"
#include <stdint.h>

struct gpu_interface {
  uint32_t status;
  uint32_t opcode;
  vertex_array_t vao;
};

#endif