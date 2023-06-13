// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {RealityEvent} from "src/RealityEvent.sol";

contract RealityEventTest is Test {
    using stdStorage for StdStorage;

    RealityEvent realityEvent;

    function setUp() public {
        realityEvent = new RealityEvent();
    }

    function testNotarize() public {
        realityEvent.notarize(
            address(1),
            1,
            RealityEvent.EventData("cool_facility_name", "a_sensor_name", 100),
            RealityEvent.ROCInfo("device_id", address(1), address(1), 100, 100)
        );

        assertEq(realityEvent.balanceOf(address(1), 1), 1);
    }

    function testGetEventData() public {
        RealityEvent.EventData memory eventData = RealityEvent.EventData(
            "cool_facility_name",
            "a_sensor_name",
            100
        );

        realityEvent.notarize(
            address(1),
            2,
            RealityEvent.EventData("cool_facility_name", "a_sensor_name", 100),
            RealityEvent.ROCInfo("device_id", address(1), address(1), 100, 100)
        );

        assertEq(realityEvent.getEventData(2).facility_name, eventData.facility_name);
        assertEq(realityEvent.getEventData(2).sensor_name, eventData.sensor_name);
        assertEq(realityEvent.getEventData(2).weight_kg, eventData.weight_kg);
    }

    function testRocInfo() public {
        RealityEvent.ROCInfo memory rocInfo = RealityEvent.ROCInfo(
            "device_id",
            address(1),
            address(1),
            100,
            100
        );

        realityEvent.notarize(
            address(1),
            3,
            RealityEvent.EventData("cool_facility_name", "a_sensor_name", 100),
            RealityEvent.ROCInfo("device_id", address(1), address(1), 100, 100)
        );

        assertEq(realityEvent.getRocInfo(3).device_id, rocInfo.device_id);
        assertEq(realityEvent.getRocInfo(3).roc_device_address, rocInfo.roc_device_address);
        assertEq(realityEvent.getRocInfo(3).roc_contract_address, rocInfo.roc_contract_address);
    }

    function testSetURI() public {
        realityEvent.setURI("https://faust.ooo/metadata.json");
        assertEq(realityEvent.uri(0), "https://faust.ooo/metadata.json");
    }
}