import Cocoa

class ListNode {
    var value: Int
    var next: ListNode?
    
    init(value: Int) {
        self.value = value
        self.next = nil
    }
}


class List {
    var head: ListNode?
    var tail: ListNode?
    
    func appendToTail(_ val: Int) {
        if tail == nil {
            tail = ListNode(value: val)
            head = tail
        } else {
            tail!.next = ListNode(value: val)
            tail = tail!.next
        }
    }
    
    func appendToHead(_ val: Int) {
        if head == nil {
            head = ListNode(value: val)
            tail = head
        } else {
            let node = ListNode(value: val)
            node.next = head
            head = node
        }
    }
}


func dumpList(_ head: ListNode?) {
    
    guard head != nil else {
        print("list is empty")
        return
    }
    
    var node = head
    while node != nil {
        print("node: \(node!.value)")
        node = node!.next
    }
}


var list = List()
dumpList(list.head)
list.appendToHead(5)
list.appendToHead(6)
list.appendToTail(1)
list.appendToTail(2)
list.appendToHead(7)
list.appendToHead(3)
dumpList(list.head) // 3 7 6 5 1 2
print("this is a line \n")


//给定一链表和值x，要求将链表中所有小于x的值放到左边，所有大于等于x的值放右边，且原链表节点顺序不变
/*
func getLeftList(_ head: ListNode?, _ x: Int) -> ListNode? {
    let dummy = ListNode(value: 0)  //可以方便的返回最终需要的头结点
    var pre = dummy, node = head
    while node != nil {
        if node!.value < x {
            pre.next = node
            pre = node!
        }
        node = node!.next
    }
    pre.next = nil
    return dummy.next
} */

func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
    
    let prevDummy = ListNode(value: 0), postDummy = ListNode(value: 0)
    var prev = prevDummy, post = postDummy, node = head
    
    while node != nil {
        if node!.value < x {
            prev.next = node
            prev = node!
        } else {
            post.next = node
            post = node!
        }
        node = node!.next
    }
    
    post.next = nil //防止链表循环指向
    prev.next = postDummy.next
    
    return prevDummy.next
}

let node = partition(list.head, 4)
dumpList(node)
print("this is a line \n")




/*
// 检测链表中是否有环
func hasCycle(_ head: ListNode?) -> Bool {
    
    var slow = head, fast = head
    
    while fast != nil && fast!.next != nil {
        slow = slow!.next
        fast = fast!.next!.next
        if slow === fast {
            return true
        }
    }
    return false
}

var list2 = List()
var tmpNode = ListNode(value: 1)
list2.appendToTail(0)
list2.tail?.next = tmpNode
list2.tail = tmpNode
list2.appendToTail(2)
list2.appendToTail(3)
list2.appendToTail(4)
list2.tail?.next = tmpNode

print(hasCycle(list2.head))

 */



//删除链表中倒数第n个节点
func removeEndNode(_ head: ListNode?, _ n: Int) -> ListNode? {
    
    guard let head = head else {
        return nil
    }
    guard n > 0 else {
        return nil
    }
    
    let dummy = ListNode(value: 0)
    dummy.next = head
    var prev: ListNode? = dummy, post: ListNode? = dummy
    
    for _ in 0 ..< n {
        if post == nil {
            break
        }
        post = post!.next
    }
    
    while post != nil && post!.next != nil {
        prev = prev!.next
        post = post!.next
    }
    
    prev!.next = prev!.next!.next
    return dummy.next
}

dumpList(list.head)
removeEndNode(list.head, 6) //边界值有问题，链表就六个值，删除倒数第六个
print("\n")
dumpList(list.head)
