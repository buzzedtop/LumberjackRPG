#!/bin/bash
# LumberjackRPG Test Runner Script
# This script runs comprehensive tests on the game mechanics

set -e

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║         LumberjackRPG - Comprehensive Test Suite Runner           ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
}

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
        return 1
    fi
}

# Track overall test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Change to project directory
cd "$(dirname "$0")"

print_section "Pre-flight Checks"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}Warning: Flutter not found in PATH${NC}"
    echo "Attempting to use dart directly..."
    if ! command -v dart &> /dev/null; then
        echo -e "${RED}Error: Neither Flutter nor Dart found in PATH${NC}"
        echo "Please install Flutter/Dart SDK"
        exit 1
    fi
    USE_DART=true
else
    echo -e "${GREEN}✓ Flutter SDK found${NC}"
    flutter --version | head -n 1
    USE_DART=false
fi

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ pubspec.yaml found${NC}"

# Check if test directory exists
if [ ! -d "test" ]; then
    echo -e "${RED}Error: test directory not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ test directory found${NC}"

print_section "Installing Dependencies"

if [ "$USE_DART" = true ]; then
    echo "Running: dart pub get"
    if dart pub get; then
        print_result 0 "Dependencies installed successfully"
    else
        print_result 1 "Failed to install dependencies"
        exit 1
    fi
else
    echo "Running: flutter pub get"
    if flutter pub get; then
        print_result 0 "Dependencies installed successfully"
    else
        print_result 1 "Failed to install dependencies"
        exit 1
    fi
fi

print_section "Running Core Mechanics Tests"

# Array of test files and their descriptions
declare -a TEST_FILES=(
    "test/lumberjack_test.dart:Player Mechanics"
    "test/wood_test.dart:Wood Resource System"
    "test/metal_test.dart:Metal Resource System"
    "test/monster_test.dart:Monster & Combat System"
    "test/axe_test.dart:Weapon System"
    "test/game_map_test.dart:Map Generation"
)

declare -a SYSTEM_TEST_FILES=(
    "test/crafting_system_test.dart:Crafting System"
    "test/building_test.dart:Building System"
    "test/town_test.dart:Town Management"
    "test/dungeon_test.dart:Dungeon System"
    "test/game_state_test.dart:Game State Integration"
)

# Run individual test files for better tracking
run_test_file() {
    local test_file=$1
    local test_name=$2
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo ""
    echo -e "${YELLOW}Running: $test_name${NC}"
    
    if [ "$USE_DART" = true ]; then
        if dart test "$test_file" 2>&1; then
            PASSED_TESTS=$((PASSED_TESTS + 1))
            print_result 0 "$test_name tests passed"
            return 0
        else
            FAILED_TESTS=$((FAILED_TESTS + 1))
            print_result 1 "$test_name tests failed"
            return 1
        fi
    else
        if flutter test "$test_file" 2>&1; then
            PASSED_TESTS=$((PASSED_TESTS + 1))
            print_result 0 "$test_name tests passed"
            return 0
        else
            FAILED_TESTS=$((FAILED_TESTS + 1))
            print_result 1 "$test_name tests failed"
            return 1
        fi
    fi
}

# Run core mechanics tests
for test_entry in "${TEST_FILES[@]}"; do
    IFS=':' read -r test_file test_name <<< "$test_entry"
    run_test_file "$test_file" "$test_name"
done

print_section "Running Game System Tests"

# Run system tests
for test_entry in "${SYSTEM_TEST_FILES[@]}"; do
    IFS=':' read -r test_file test_name <<< "$test_entry"
    run_test_file "$test_file" "$test_name"
done

print_section "Running All Tests Together"

# Run all tests together for comprehensive coverage
echo ""
echo -e "${YELLOW}Running complete test suite...${NC}"
if [ "$USE_DART" = true ]; then
    if dart test; then
        print_result 0 "Complete test suite passed"
    else
        print_result 1 "Some tests in complete suite failed"
    fi
else
    if flutter test; then
        print_result 0 "Complete test suite passed"
    else
        print_result 1 "Some tests in complete suite failed"
    fi
fi

print_section "Test Coverage Summary"

echo ""
echo "Test Categories Covered:"
echo "  ✓ Player mechanics (movement, combat, leveling)"
echo "  ✓ Resource gathering (wood & metal)"
echo "  ✓ Monster spawning and combat"
echo "  ✓ Weapon crafting and upgrades"
echo "  ✓ Map generation and biomes"
echo "  ✓ Crafting system"
echo "  ✓ Building construction and production"
echo "  ✓ Town management and resources"
echo "  ✓ Dungeon exploration and progression"
echo "  ✓ Game state integration and time system"
echo ""

print_section "Final Test Results"

echo ""
echo "Total Test Suites: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
if [ $FAILED_TESTS -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED_TESTS${NC}"
fi

# Calculate success rate
SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo ""
echo "Success Rate: $SUCCESS_RATE%"

if [ $SUCCESS_RATE -eq 100 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    🎉 ALL TESTS PASSED! 🎉                         ║${NC}"
    echo -e "${GREEN}║           All game mechanics are working correctly!                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    exit 0
elif [ $SUCCESS_RATE -ge 80 ]; then
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                 Most tests passed successfully                     ║${NC}"
    echo -e "${YELLOW}║              Please review failed tests above                      ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════════════╝${NC}"
    exit 1
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                   Multiple tests failed                            ║${NC}"
    echo -e "${RED}║             Please review output above for details                 ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
