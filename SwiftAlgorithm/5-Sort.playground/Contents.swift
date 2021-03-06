import Cocoa


//冒泡排序  时间复杂度O(n^2)  空间复杂度O(1)  稳定
//插入排序  O(n^2)     O(1)   稳定
//选择排序  O(n^2)    O(1)    不稳定
//堆排序    O(nlogn)   O(1)   不稳定
//归并排序  O(nlogn)   O(n)   稳定
//快速排序  O(nlogn)   O(logn)  不稳定
//桶排序   O(n)        O(k)   稳定

// 归并排序
func myMerge(_ array: inout [Int], _ helper: inout [Int], _ low: Int, _ middle: Int, _ high: Int) {
    //print("array=\(array) helper=\(helper) low=\(low) middle=\(middle) high=\(high)")
    for i in low ... high {
        helper[i] = array[i]
    }
    var helperLeft = low, helperRight = middle + 1, current = low
    while helperLeft <= middle && helperRight <= high {
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperLeft]
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
    //print("array = \(array)")
}

func myMergeSort(_ array: inout [Int], _ helper: inout [Int], _ low: Int, _ high: Int) {
    guard low < high else {
        return
    }
    
    let middle = (high - low) / 2 + low
    myMergeSort(&array, &helper, low, middle)
    myMergeSort(&array, &helper, middle + 1, high)
    myMerge(&array, &helper, low, middle, high)
}

func myMergeSort(_ array: [Int]) -> [Int] {
    var helper = Array(repeating: 0, count: array.count), array = array
    myMergeSort(&array, &helper, 0, array.count - 1)
    return array
}

//var array1 = [10,2,3,7,5,3,8,4,6,9,1]
//print(myMergeSort(array1)) //[1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10]





// 快速排序
func quickSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    
    let pivot = array[array.count / 2]
    let left = array.filter { $0 < pivot }
    let middle = array.filter{ $0 == pivot }
    let right = array.filter{ $0 > pivot }
    
    return quickSort(left) + middle + quickSort(right)
}

/*
var array2 = [10,2,3,7,5,3,8,4,6,9,1]
array2.sort() //[1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10]
array2.sort(by: >) //[10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 1]
//Java中，自带sort函数部分是用归并排序实现的
//Swift中 sort函数是一种内省算法 IntroSort,
//由堆排序、插入排序、快速排序三种算法构成，根据输入深度选择最佳的算法来完成。
 */

/*
var dict = ["1":"a", "3":"c", "2":"b"]
let keys = Array(dict.keys) //["2", "3", "1"]
let sortKeys = keys.sorted(){
    return dict[$0]! > dict[$1]!
}
print("sort keys = \(sortKeys)") //sort keys = ["3", "2", "1"]
*/
