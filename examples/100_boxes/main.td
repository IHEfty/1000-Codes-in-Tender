import "helper/randint"

// Step 1: Generate a random permutation of numbers 1 to 100 for the boxes.
boxes := {}
nums := []
for i in range(1, 101) {
    nums.push(i)
}

// Fisher–Yates shuffle to randomize the array.
for i in range(0, 100) {
    // Choose a random index between i and 99 (inclusive).
    j := randint(i, 99)
    temp := nums[i]
    nums[i] = nums[j]
    nums[j] = temp
}

// Assign the shuffled numbers to boxes (1-indexed).
for i in range(1, 101) {
    boxes[i] = nums[i - 1]
}

// Step 2: Simulate the prisoners' strategy with detailed logging.
prisonersSurvived := true

for prisoner in range(1, 101) {
    println("Prisoner " + prisoner + " is entering the room.")
    currentBox := prisoner
    found := false
    
    // Each prisoner gets 50 chances.
    for attempt in range(1, 51) {
        println("Prisoner " + prisoner + " attempt " + attempt + ": checking box " + currentBox + " (contains " + boxes[currentBox] + ").")
        if boxes[currentBox] == prisoner {
            println("Prisoner " + prisoner + " found their number in box " + currentBox + " on attempt " + attempt + ".")
            found = true
            break  // Prisoner found their number.
        }
        // Follow the chain: next box to open is the number found in the current box.
        currentBox = boxes[currentBox]
    }
    
    if !found {
        println("Prisoner " + prisoner + " failed to find their number in 50 attempts.")
        prisonersSurvived = false
        break
    }
}

// Step 3: Report the outcome.
if prisonersSurvived {
    println("All prisoners found their number and escape!")
} else {
    println("At least one prisoner failed. All prisoners are executed.")
}
