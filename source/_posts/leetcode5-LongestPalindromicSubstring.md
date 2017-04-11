title: leetcode5 Longest Palindromic Substring

date: 2017/04/11 15:00:00

categories:

- Study

tags:

- leetcode
- string
- palindrome

---

## leetcode#5 Longest Palindromic Substring

>Given a string **s**, find the longest palindromic substring in **s**. You may assume that the maximum length of **s** is 1000.
>
>**Example:**
>
>```
>Input: "babad"
>
>Output: "bab"
>
>Note: "aba" is also a valid answer.
>```
>
>**Example:**
>
>```
>Input: "cbbd"
>
>Output: "bb"
>```

##### 解释：

给定一个字符串，返回其中最长的回文子串，若有多个长度相等的回文子串，则返回第一个出现的回文子串即可。

##### 理解：

回文，即不论正向，还是反向，都是一样的。

直观上的解法，即中心扩散法，需要从字符串的第一个字符开始，遍历所有的字符，利用`String.charAt(i)`；每次访问其中的一个字符的时候，以该字符为中心，通过不断比较以该字符为中心的两侧字符，若相同，则逐渐扩大回文子串的范围；最后，哪一个回文子串拥有最大的长度，则将最长的回文子串通过`String.substring(low,high)`摘取出来并返回。

##### 我的解法：

直观上的解法，理解起来十分的容易，但是会面临一个问题：**字符串所含字符个数的奇偶性**。

直观上对于奇偶性的解决办法，只能是**遍历两次**，一次遍历假设字符个数是奇数，另一次遍历假设字符个数是偶数，最后从获得的结果来看，哪一个回文子串的长度更长。

在阅读《编程之法》后，我学习到了新的算法——马拉车算法（Manacher），修改了一下得到了我的解法。基本的思想是：

首先，在原字符串的每个字符之间添加字符“#”，使得新的字符串的长度始终为奇数（同时，可以额外地在新构建的字符串的起始位置添加“$”，标识字符串的起始）；

其次，可以推导出以下关系：

（推导略，可以分为`mx-i>p[i]`和`mx-i<=p[i]`两种情况，然后作图）

`mx > i时，有p[i] >= MIN(p[2*id - i],mx - i)` 

- `id`表示新创建的字符串中，当前遍历到的最长回文子串中心的位置；
- `mx`表示当前最长回文子串的后边界，即`mx = id + p[id]`；
- `p[i]`则表示以当前`i`位置字符为中心的回文子串，向左或者向右一个方向最多能扩展的长度。

这样一来，就可以在避免字符串中字符个数奇偶性的问题的同时，避开了每次访问一个字符串中的字符，都从该字符的两侧距离为1的字符开始比较，而是从**距离当前字符`p[i] = MIN(p[2*id - i],mx - i)`的两侧位置**开始比较（因为，如果前一个回文子串的范围已经包含了接下来将要访问的字符串中的某个字符，以及以该字符为中心的一段字符串，再比较这一段被包含的字符串是没有用的，因为只要`i`在`id`和`mx`之间，如果以`i`为中心的回文子串长度大于以`id`为中心的回文子串，则以`i`为中心，范围为`mx - i`的两侧必定**对称相等**，不信可以试一试，暂时不懂证明）

时间复杂度`O(n)`，空间复杂度`O(n)`

```
public class Solution {
    public String longestPalindrome(String str) {
        if(str.length() <= 1){ return str; }

        String buildStr = preProcess(str);// 预处理，添加字符#，使得新得到的字符串长度为奇数
        
        int id = 0;
        int mx = 0;
        int freq = 0;// 用于保存当前最大的p[i]值，即当前最长回文子串一个方向的最大长度
        int maxId = 0;// 当前最长回文子串的中心在新创建的字符串中的位置
        int maxMx = 0;// 实质上就是 p[maxId]
        int[] p = new int[buildStr.length()];
        
        for(int i = 1;i < buildStr.length(); i++) {
            if(mx > i) { p[i] = p[2*id - i] > (mx - i) ? (mx - i) : p[2*id - i]; }
            else{ p[i] = 1; }
            
            while((i + p[i] < buildStr.length()) && buildStr.charAt(i + p[i]) == buildStr.charAt(i - p[i])) { p[i]++; }
            if(p[i] +i >mx) {
                mx = p[i] +i;
                id = i;
            }
            if(p[i] > freq) {
                freq = p[i];
                maxId = id;
                maxMx = mx - id;
            }
        }
        // delete "$" and "#"
         String subStr = buildStr.substring((maxId - maxMx + 1),(maxId + maxMx));
        StringBuilder newStr = new StringBuilder();
        for(int i = 0;i< subStr.length();i++) {
            if(subStr.charAt(i) != '$' && subStr.charAt(i) != '#') {
                newStr.append(subStr.charAt(i));
            }
        }
        return newStr.toString();
    }

    private String preProcess(String str) {
        StringBuilder buildStr = new StringBuilder();
        // 由于JAVA的字符串是常量，所以不能直接操作原字符串，需要通过 StringBuilder 来构建新的字符串，最后再通过 String.toString() 返回一个构建好的字符串
        buildStr.append("$");
        for(int i = 0;i < str.length();i++) {
            buildStr.append("#");
            buildStr.append(str.charAt(i));
        }
        buildStr.append("#");
        return buildStr.toString();
    }
}
```

##### 大神解法：

中心扩散法

采用了最直观的方法，即对字符串进行了两次遍历，记录回文子串的长度和子串的最低位。通过比较回文子串的长度得出最大长度，然后利用最长回文子串的最低位和长度摘取并返回子串。

时间复杂度`O(n^2)`，空间复杂度`O(1)`

```
public class Solution {
private int lo, maxLen;

public String longestPalindrome(String s) {
	int len = s.length();
	if (len < 2)
		return s;
	
    for (int i = 0; i < len-1; i++) {
     	extendPalindrome(s, i, i);  //assume odd length, try to extend Palindrome as possible
     	extendPalindrome(s, i, i+1); //assume even length.
    }
    return s.substring(lo, lo + maxLen);
}

private void extendPalindrome(String s, int j, int k) {
	while (j >= 0 && k < s.length() && s.charAt(j) == s.charAt(k)) {
		j--;
		k++;
	}
	if (maxLen < k - j - 1) {
		lo = j + 1;
		maxLen = k - j - 1;
	}
}}
```

其他解法还包括：暴力解法（时间复杂度`O(n^3)`，空间复杂度`O(1)`）和动态规划法（时间复杂度`O(n^2)`，空间复杂度`O(n^2)`），可以参照以下链接进行阅读： https://segmentfault.com/a/1190000002991199

### 总结：

本题其实直观上是比较明显的，可以直接想到中心扩散法，但是要想到对称、想到一系列的数学关系，最后得出Manacher算法还是比较巧妙的。

此外，由于JAVA字符串的常量性，在实现的过程中，还需要借助不少JAVA库中String的方法，这对JAVA的知识掌握的要求还是比较高的。

#### 挖个坑......之后会写关于JAVA知识的总结

