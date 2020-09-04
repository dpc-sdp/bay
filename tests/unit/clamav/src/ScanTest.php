<?php

namespace DpcSdpTests;

use PHPUnit\Framework\TestCase;

/**
 * Verify files can be scanned correctly.
 */
class ScanTest extends ClamTestBase {

  /**
   * Ensure the service can be connected to.
   */
  public function testConnection() {
    $this->assertTrue($this->ping());
  }

  /**
   * Ensure that the virus scanner can block a virus.
   */
  public function testBlockVirus() {
    $file_path = dirname(__FILE__, 2) . '/fixtures/eicar.com.txt';

    list($result, $virus_string) = $this->file($file_path);

    $this->assertEquals(self::FILE_VIRUS, $result);
    $this->assertEquals('Win.Test.EICAR_HDB-1', $virus_string);
  }

  /**
   * Ensure that the virus scanner returns the correct status for safe files.
   */
  public function testSafeFile() {
    $file_path = dirname(__FILE__, 2) . '/fixtures/Nala-the-cat-shark-hat.jpg';

    list($result, $virus_string) = $this->file($file_path);

    $this->assertEquals(self::FILE_SAFE, $result);
    $this->assertNull($virus_string);
  }

}
