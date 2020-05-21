import re

files = ["leetcode.md"]

for file in files:
    with open('leetcode.md') as f, open('leetcode.md', 'w') as wf:
        content = f.read()
        pattern = r'```([\w\+]+)\n.*?```'
        sub = '''
    <details>
        <summary>\g<1> 解答</summary>

    \g<0>
    </details>
    '''
        content = re.sub(pattern, sub, content, flags=re.DOTALL)
        wf.write(content)
