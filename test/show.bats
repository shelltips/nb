#!/usr/bin/env bats

load test_helper

# `notes show` ################################################################

@test "\`show\` with no argument exits with status 1." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`show\` with no argument does not show the note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  skip "TODO: Determine how to test for \`\$PAGER\`."
}

@test "\`show\` with no argument prints help information." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  notes show (<id> | <filename> | <path> | <title>)" ]]
}

# `notes show --dump` #########################################################

@test "\`show --dump\` with argument exits with 0 and prints note with highlighting." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add "# Example"
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
  [[ ! "${lines[0]}" =~ "# Example" ]]
  [[ "${lines[0]}" =~ "Example" ]]
}

@test "\`show --dump --no-color\` with argument exits with 0 and prints note without highlighting." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add "# Example"
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --dump --no-color
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
  [[ "${lines[0]}" =~ "# Example" ]]
}

@test "\`show --dump\` with no argument exits with status 1." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add "# Example"
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`show --dump\` with no argument does not dump the note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add "# Example"
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _original="$(cat "${NOTES_DATA_DIR}/${_filename}")"

  run "${_NOTES}" show --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ! "${output}" =~ mock_editor ]]
}

@test "\`show --dump\` with no argument prints help information." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add "# Example"
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  notes show (<id> | <filename> | <path> | <title>)" ]]
}

# <selector> ##################################################################

@test "\`show <selector>\` with empty repo exits with 1 and prints help." {
  {
    run "${_NOTES}" init
  }

  run "${_NOTES}" show 1
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  notes show (<id> | <filename> | <path> | <title>)" ]]
}

# `notes show <filename> --dump` ##############################################

@test "\`show <filename> --dump\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <filename> --dump\` dumps note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" =~ mock_editor ]]
}

# `notes show <id> --dump` ####################################################

@test "\`show <id> --dump\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <id> --dump\` dumps note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" =~ mock_editor ]]
}

# `notes show <path> --dump` #################################################

@test "\`show <path> --dump\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <path> --dump\` dumps note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" =~ mock_editor ]]
}

# `notes show <title> --dump` #################################################

@test "\`show <title> --dump\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${_title}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <title> --dump\` dumps note file." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${_title}" --dump
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" =~ mock_editor ]]
}

# `notes show <filename> --path` ##############################################

@test "\`show <filename> --path\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <filename> --path\` prints note file path." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "${NOTES_DATA_DIR}/${_filename}" ]]
}

# `notes show <id> --path` ####################################################

@test "\`show <id> --path\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <id> --path\` prints note file path." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "${NOTES_DATA_DIR}/${_filename}" ]]
}

# `notes show <path> --path` #################################################

@test "\`show <path> --path\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <path> --path\` prints note file path." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "${NOTES_DATA_DIR}/${_filename}" ]]
}

# `notes show <title> --path` #################################################

@test "\`show <title> --path\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${_title}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <title> --path\` prints note file path." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${_title}" --path
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "${NOTES_DATA_DIR}/${_filename}" ]]
}

# `notes show <filename> --id` ################################################

@test "\`show <filename> --id\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <filename> --id\` prints note file id." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "1" ]]
}

# `notes show <id> --id` ######################################################

@test "\`show <id> --id\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <id> --id\` prints note file id." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show 1 --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "1" ]]
}

# `notes show <path> --id` ####################################################

@test "\`show <path> --id\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <path> --id\` prints the note file id." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "1" ]]
}

# `notes show <title> --id` ###################################################

@test "\`show <title> --id\` exits with status 0." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <title> --id\` prints the note file id." {
  {
    run "${_NOTES}" init
    run "${_NOTES}" add
    _files=($(ls "${NOTES_DATA_DIR}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NOTES_DATA_DIR}/${_filename}" | sed 's/^\# //')"

  run "${_NOTES}" show "${NOTES_DATA_DIR}/${_filename}" --id
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "1" ]]
}

# help ########################################################################

@test "\`help show\` exits with status 0." {
  run "${_NOTES}" help show
  [[ ${status} -eq 0 ]]
}

@test "\`help show\` prints help information." {
  run "${_NOTES}" help show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  notes show (<id> | <filename> | <path> | <title>)" ]]
}
