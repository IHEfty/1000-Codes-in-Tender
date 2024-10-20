counter := 0
for {
    println("Counter:", counter)
    counter += 1
    
    if counter == 10 {
        println("Breaking the loop!")
        // break
    }
}
