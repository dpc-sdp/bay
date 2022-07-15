<?php

namespace DpcSdpTests;

use PHPUnit\Framework\TestCase;

/**
 * Provide a base class for ClamAV helper functions.
 */
class ClamTestBase extends TestCase {

  /**
   * If the file is safe.
   */
  const FILE_SAFE = 0;

  /**
   * If the file has a virus.
   */
  const FILE_VIRUS = -1;

  /**
   * If the file doesn't exist.
   */
  const FILE_NOT_EXIST = -2;

  /**
   * If the daemon can't scan the file.
   */
  const FILE_NOT_SCANNED = -3;

  /**
   * The clamav host.
   *
   * @var string
   */
  protected $host;

  /**
   * The clamav port.
   *
   * @var int
   */
  protected $port;

  /**
   * Build the test clss.
   */
  public function __construct() {
    $this->host = getenv('CLAMAV_HOST') ?: 'clamav';
    $this->port = getenv('CLAMAV_PORT') ?: 3000;
    parent::__construct();
  }

  /**
   * Connect the clamav service.
   *
   * @return mixed
   *   The filepointer to the clam service.
   */
  public function connect() {
    $socket_handle = @fsockopen($this->host, $this->port);

    if (!$socket_handle) {
      throw new \Exception('Error: Unlable to connect via tcp/ip to the clam daemon.');
    }

    return $socket_handle;
  }

  /**
   * Ensure the service responds.
   *
   * @return bool
   *   If the service responds.
   */
  public function ping() {
    $ch = $this->connect();
    fwrite($ch, "zPING\0");
    $response = trim(fgets($ch));
    fclose($ch);
    return $response == "PONG";
  }

  /**
   * Send a command to the clamav service.
   *
   * @param string $command
   *   The clamav command.
   *
   * @return string
   *   The unparsed socket output.
   */
  public function send($command) {
    $ch = $this->connect();
    fwrite($ch, $command);
    $response = trim(fgets($ch));
    fclose($ch);
    return $response;
  }

  /**
   * Send a file to the clamav service.
   *
   * @param string $path
   *   The path to the file to send.
   *
   * @return array
   *   The scan status and the message.
   */
  public function file($path) {
    $ch = $this->connect();

    if (!file_exists($path)) {
      return [self::FILE_NOT_EXIST, NULL];
    }

    $fh = fopen($path, "r");

    // Prepare to send the file.
    fwrite($ch, "zINSTREAM\0");
    fwrite($ch, pack("N", filesize($path)));
    stream_copy_to_stream($fh, $ch);

    // End the stream.
    fwrite($ch, pack("N", 0));

    $response = trim(fgets($ch));

    fclose($ch);
    fclose($fh);

    if (preg_match('/^stream: OK$/', $response)) {
      return [self::FILE_SAFE, NULL];
    }

    if (preg_match('/^stream: (.*) FOUND$/', $response, $matches)) {
      return [self::FILE_VIRUS, $matches[1]];
    }

    return [self::FILE_NOT_SCANNED, NULL];
  }

}
