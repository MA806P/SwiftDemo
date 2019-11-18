import Cocoa



// 二叉树  每个节点最多有两个子节点
// 深度  二叉树查找  二叉树遍历

//二叉树本事是由递归定义的，从原理上讲，所有二叉树题目都可用递归来解
//注意处理节点为 nil 的情况，根节点为 nil 的情况。

public class TreeNode {
    public var value: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.value = val
    }
}

var tree = TreeNode(10)
var tree21 = TreeNode(6)
var tree22 = TreeNode(16)
tree.left = tree21
tree.right = tree22
var tree31 = TreeNode(2)
var tree32 = TreeNode(8)
tree21.left = tree31
tree21.right = tree32
var tree33 = TreeNode(12)
var tree34 = TreeNode(18)
tree22.left = tree33
tree22.right = tree34


//计算树的最大深度
func maxDepth(root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }
    return max(maxDepth(root: root.left), maxDepth(root: root.right)) + 1
}

print(maxDepth(root: tree)) //3


//二叉查找树，一种特殊的二叉树，左子树节点的值都小于根节点的值，右子树节点的值都大于根节点的值
//判断是否为二叉查找树
func isValidBST(root: TreeNode?) -> Bool {
    return _helper(node: root, nil, nil)
}
private func _helper(node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
    guard let node = node else {
        return true
    }
    //左子树节点必须小于根节点
    if let max = max, node.value >= max {
        return false
    }
    //右子树节点必须大于跟节点
    if let min = min, node.value <= min {
        return false
    }
    return _helper(node: node.left, min, node.value) && _helper(node: node.right, node.value, max)
}
print(isValidBST(root: tree)) //true




//二叉树的遍历
//前序、中序、后序遍历，3中写法相似。递归。面试可能要求用非递归的方法实现

//用栈实现前序遍历
func preorderTraversal(root: TreeNode?) -> [Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    while stack.isEmpty == false || node != nil {
        if node != nil {
            res.append(node!.value)
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast().right
        }
    }
    return res
}
let result = preorderTraversal(root: tree)
print("pre result = \(result)") // [10, 6, 2, 8, 16, 12, 18]


//层级遍历(广度优先遍历)  [[10] [6 16] [2 8 12 18]]
//前序、中序、后序遍历，至少需要两种遍历方式的结果，才能确定一棵树
//层级遍历，知道结果，就可以唯一确定一棵树

//层级遍历就是图的广度优先遍历
//用队列来实现输的层级遍历
func levelOrder(root: TreeNode?) -> [[Int]] {
    var res = [[Int]]()
    //用数组实现队列
    var queue = [TreeNode]()
    if let root = root {
        queue.append(root)
    }
    while queue.count > 0 {
        let size = queue.count
        var level = [Int]()
        for _ in 0 ..< size {
            let node = queue.removeFirst()
            level.append(node.value)
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        res.append(level)
    }
    return res
}
let levelRes = levelOrder(root: tree)
print("level result = \(levelRes)") //[[10], [6, 16], [2, 8, 12, 18]]
