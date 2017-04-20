title: leetcode125 Valid Palindrome

date: 2017/04/14 21:00:00

categories:

- Study

tags:

- leetcode
- string
- Palindrome

---

## leetcode#125 Valid Palindrome

>Given a string, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.
>
>For example,
>`"A man, a plan, a canal: Panama"` is a palindrome.
>`"race a car"` is *not* a palindrome.
>
>**Note:**
>Have you consider that the string might be empty? This is a good question to ask during an interview.
>
>For the purpose of this problem, we define empty string as valid palindrome.

##### 解释：

给定一个字符串，判断该字符串是否是回文字符串，只考虑字母和数字，不考虑大小写。

例如：

`A man, a plan, a canal: Panama` 是一个回文字符串。
`race a car` 不是一个回文字符串。

注意：

怎么考虑一个空字符串？（这是一个好问题）

这里就定义，空字符串也是一个回文字符串。

##### 理解：

本题是判断**一整个字符串**是否有回文，所以可以用两个指针，分别指向字符串的起始与结束的位置，然后由两端逐渐往中部移动，并在移动的过程中进行字符的比较。

由于本题只考虑字母和数字，同时不考虑字母的大小写，因此在判断字符**ASCII码范围**之外，还需要在遇到字母的时候，**变换大小写**以便判断是否是同一个字母。

##### 我的解法：

```
public class Solution {
    public boolean isPalindrome(String s){
        if(s.length() == 0) { return true; }
        int head = 0;
        int tail = 0;
        char charFront = ' ';
        char charBack = '.';
        for(int i = 0;i < s.length() - 1;i++) {
            tail++;
        }
        while(head < tail) {
            boolean flagFront = true;
            boolean flagBack = true;
            // 字母和数字的ASCII码：0~9(48-57) A~Z(65-90) a~z(97-122)
            while(flagFront) {
                if((s.charAt(head) >=48 && s.charAt(head) <= 57) || (s.charAt(head) >= 65 && s.charAt(head) <= 90) || (s.charAt(head) >= 97 && s.charAt(head) <= 122)) {
                    charFront = s.charAt(head);
                    flagFront = false;
                }
                else{
                    head++;
                    if(head >= s.length()) { return true; }
                }
            }
            while(flagBack) {
                if((s.charAt(tail) >=48 && s.charAt(tail) <= 57) || (s.charAt(tail) >= 65 && s.charAt(tail) <= 90) || (s.charAt(tail) >= 97 && s.charAt(tail) <= 122)) {
                    charBack = s.charAt(tail);
                    flagBack = false;
                }
                else{ tail--; }
            }

            if(charFront == charBack) {
                tail--;
                head++;
            }
            else if((charFront - 48 >= 0 && charFront - 48 <= 9) || (charBack - 48 >= 0 && charBack - 48 <= 9)) {
                 return false;
            }
            else if(charFront - 32 == charBack || charBack - 32 == charFront) {
                tail--;
                head++;
            }
            else{
                return false;
            }
        }
        return true;
    }
}
```

##### 大神解法：

解法一：

非常的简洁，用到了很多String的方法：

- String.replaceAll(String regex, String r)，利用字符串 r 替换原字符串中符合**正则表达式** regex 的字符串部分；
- String.toLowerCase()，将字符串中的字母全部转换成小写的形式；
- StringBuffer(String s)，由于字符串是常量，所以想要生成原字符串的逆序字符串，必须新创建一个字符串，可以使用StringBuffer（速度较慢，但是线程安全），也可以使用StringBuilder（速度较快，但是非线程安全）；
- StringBuffer.reverse()，还处于StringBuffer阶段时，还不是字符串常量，所以此时还是可以对其进行逆序操作的；
- StringBuffer.toString()，将StringBuffer对象转换为字符串常量。

由于用到了很多库方法，其速度自然会很慢。

```
public class Solution {
    public boolean isPalindrome(String s) {
        String actual = s.replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        String rev = new StringBuffer(actual).reverse().toString();
        return actual.equals(rev);
    }
}
```

解法二：

本解法的思想与我得解法的思想一致，但是它在判断数字和字母的时候，采用了**JAVA库方法**——Character.isLetterOrDigit(char c)，看起来会整洁许多，但是势必会造成程序运行速度的下降。 

```
public class Solution {
    public boolean isPalindrome(String s) {
        if (s.isEmpty()) {
        	return true;
        }
        int head = 0, tail = s.length() - 1;
        char cHead, cTail;
        while(head <= tail) {
        	cHead = s.charAt(head);
        	cTail = s.charAt(tail);
        	if (!Character.isLetterOrDigit(cHead)) {
        		head++;
        	} else if(!Character.isLetterOrDigit(cTail)) {
        		tail--;
        	} else {
        		if (Character.toLowerCase(cHead) != Character.toLowerCase(cTail)) {
        			return false;
        		}
        		head++;
        		tail--;
        	}
        }
        
        return true;
    }
}
```

### 总结：

JAVA库方法固然给程序的编写带来了方便，缩短了开发周期，但是在考虑性能和运行速度的时候，往往还是需要注意一下库方法的使用频率，时间允许的情况下，可以考虑造一个性能更优、更适合当前场景的“轮子”。