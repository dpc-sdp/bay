<?php

/**
 * @file
 *
 * Adds a shutdown function that logs fatal errors along with the REQUEST_URI.
 *
 * Intention is to allow tracking of specific routes that exhaust memory limit.
 */

/**
 * Returns a list of error types the custom error handler should respond to.
 */
function bay_fatal_error_types() {
  return [
    E_ERROR => 'E_ERROR',
    E_PARSE => 'E_PARSE',
    E_CORE_ERROR => 'E_CORE_ERROR',
    E_COMPILE_ERROR => 'E_COMPILE_ERROR',
  ];
}

register_shutdown_function(function() {
  $error = error_get_last();
  $types = bay_fatal_error_types();
  if ($error && in_array($error['type'], array_keys($types))) {
    $data = [
      'type' => $types[$error['type']],
      'message' => $error['message'],
      'request_uri' => $_SERVER['REQUEST_URI'] ?: 'N/A',
    ];
    error_log("[BAY_FATAL] " . json_encode($data));
  }
});
