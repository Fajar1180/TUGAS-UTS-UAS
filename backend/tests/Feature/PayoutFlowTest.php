<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;

class PayoutFlowTest extends TestCase
{
  use RefreshDatabase;

  /** @test */
  public function aggregation_command_runs()
  {
    $this->markTestIncomplete('Integration test scaffold');
  }
}
