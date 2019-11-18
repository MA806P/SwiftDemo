import Cocoa



// 归并排序
func merge( array: inout [Int], _ helper: inout [Int], _ low: Int, _ middle: Int, _ high: Int) {
    
    for i in low ... high {
        helper[i] = array[i]
    }
    
    var helperLeft = low, helperRight = middle + 1, current = low
    
    while helperLeft <= middle && helperRight <= high {
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperRight]
            helperLeft += 1
        } else {
            array[current] = helper[helperRight]
            helperRight += 1
        }
        current += 1
    }
    
    guard middle - helperLeft >= 0 else {
        return
    }
    
    for i in 0 ... middle - helperLeft {
        array[current + i] = helper[helperLeft + i]
    }
}

