import Cocoa

//搜索

//二分搜索，在有序数组中搜索，O(logn)
//nums 升序数组
func binarySearch(_ nums: [Int], _ target: Int) -> Bool {
    var left = 0, mid = 0, right = nums.count - 1
    while left <= right {
        // (right + left) / 2 如果数组很长，当搜索到最右边部分时，相加数会很大，造成溢出，导致崩溃
        mid = (right - left) / 2 + left
        if nums[mid] == target {
            return true
        } else if nums[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return false
}
let numbers = [0,1,2,3,4,5,6,7,8,9]
print("search = \(binarySearch(numbers, 0)) \(binarySearch(numbers, 9)) \(binarySearch(numbers, 6)) \(binarySearch(numbers, 19))")
//search = true true true false


//递归实现二分搜索
func myBinarySearch(_ nums: [Int], _ target: Int) -> Bool {
    return binarySearch(nums: nums, target: target, left: 0, right: nums.count - 1)
}
func binarySearch(nums: [Int], target: Int, left: Int, right: Int) -> Bool {
    guard left <= right else {
        return false
    }
    
    let mid = (right - left) / 2 + left
    if nums[mid] == target {
        return true
    } else if nums[mid] < target {
        return binarySearch(nums: nums, target: target, left: mid + 1, right: right)
    } else {
        return binarySearch(nums: nums, target: target, left: left, right: mid - 1)
    }
}
print("search = \(myBinarySearch(numbers, 0)) \(myBinarySearch(numbers, 9)) \(myBinarySearch(numbers, 6)) \(myBinarySearch(numbers, 19))")
//search = true true true false










///*****************************************************************************



//题目，有很多会议，如有时间重叠，则合并。3-5点，4-6点，合并为3-6点。
public class MeetingTime {
    public var start: Int
    public var end: Int
    public init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
    
}
var meeting1 = MeetingTime(start: 1, end: 4)
var meeting2 = MeetingTime(start: 2, end: 5)
var meeting3 = MeetingTime(start: 2, end: 3)
var meeting4 = MeetingTime(start: 7, end: 9)
var meetingTimes = [meeting4, meeting2, meeting3, meeting1]

/*
meetingTimes.sort() {
    if $0.start != $1.start {
        return $0.start < $1.start
    } else {
        return $0.end < $1.end
    }
}
for i in 0 ..< meetingTimes.count {
    print("\(meetingTimes[i].start) -- \(meetingTimes[i].end)")
}
*/


func mergeMeeting(meetingTimes: [MeetingTime]) -> [MeetingTime] {
    guard meetingTimes.count > 1 else {
        return meetingTimes
    }
    
    //排序
    let tmpMeetingTimes = meetingTimes.sorted() {
        if $0.start != $1.start {
            return $0.start < $1.start
        } else {
            return $0.end < $1.end
        }
    }
    
    for i in 0 ..< tmpMeetingTimes.count {
        print("\(tmpMeetingTimes[i].start) -- \(tmpMeetingTimes[i].end)")
    }
    print("\n")
    
    
    //遍历数组，合并
    var res = [MeetingTime]()
    res.append(tmpMeetingTimes[0])
    for i in 1 ..< tmpMeetingTimes.count {
        let last = res[res.count - 1]
        let current = tmpMeetingTimes[i]
        if current.start > last.end {
            res.append(current)
        } else {
            last.end = max(last.end, current.end)
        }
    }
    
    return res
}

var meetingResultArray = mergeMeeting(meetingTimes: meetingTimes)
/*
 1 -- 4
 2 -- 3
 2 -- 5
 7 -- 9
 */
for i in 0 ..< meetingResultArray.count {
    print("\(meetingResultArray[i].start) -- \(meetingResultArray[i].end)")
}
/*
 1 -- 5
 7 -- 9
 */





///*****************************************************************************

//猜数字
func isBadNumber(_ value: Int) -> Bool {
    let target = 75
    if value >= target {
        return true
    } else {
        return false
    }
}

func guessNumber(range: Int) -> Int {
    guard range >= 1 else {
        return range
    }
    
    var left = 0, mid = 0, right = range
    while left < right {
        mid = (right - left) / 2 + left
        if isBadNumber(mid) {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return left //right 一样
}
print("guess = \(guessNumber(range: 100))")




///*****************************************************************************

//搜索旋转有序数列
//[0,1,2,4,5,6,7,8,9] 在4这个位置上旋转后变为，[4,5,6,7,8,9,0,1,2]
//判断旋转点，靠前还是靠后， mid > left 旋转点靠后，前半部分可以进行二分搜索
//上面旋转后搜索 1，取中间 8，大于1，左边排除缩小了一半的搜索范围，右边一半又是一个旋转有序数列，同样的方法处理

func search(nums: [Int], target: Int) -> Int {
    var (left, mid, right) = (0, 0, nums.count - 1)
    while left <= right {
        mid = (right - left) / 2 + left
        if nums[mid] == target {
            return mid
        }
        
        if nums[mid] > nums[left] {
            if nums[mid] > target && target >= nums[left] {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else if nums[mid] < nums[left] {
            if nums[mid] < target && target <= nums[right] {
                left = mid + 1
            } else {
                right = mid - 1
            }
        } else {
            left += 1 //数组中有重复的情况
        }
    }
    return -1
}
//let searchArray = [4,5,6,7,8,9,0,1,2]
//print(search(nums: searchArray, target: 1)) //7
//print(search(nums: searchArray, target: 3)) //-1
//如果数组有重复值呢
let searchArray = [3,4,5,6,7,8,9,2,2,2,2]
print(search(nums: searchArray, target: 2)) //8
print(search(nums: searchArray, target: 4)) //1
