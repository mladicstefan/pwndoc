# PwnDoc 

Effortlessly report to other people how u pwned them, or sumn like that.

## 1. Vulnerability Card: `#htb-card`

Use this function to document a single finding, including the exploit and remediation.

### Usage
````typst
#htb-card(
  title: "Vulnerability Name Goes Here",
  severity: "critical", // Options: "critical", "high", "medium", "low", "info"
  ip: "10.10.11.247",
  port: "80/tcp",
  service: "Apache 2.4.52",
  finding: "Detailed description of the vulnerability and its impact.",
  exploit: ```
// Multiline code block for exploit steps or proof-of-concept
sqlmap -u "http://10.10.11.247/login.php"
  ```.text,
  remediation: "Clear, actionable steps for the client to fix the issue.",
)
`````

## 2\. Tool Reference: `#tool-explain`

Use this for the **Tools Reference** section to quickly document the primary tools used.

### Usage

```typst
#tool-explain(
  tool-name: "Nmap",
  description: "Network exploration and security scanning tool.",
  flags: (
    (
      flag: "-sS",
      name: "TCP SYN Scan",
      desc: "Stealth scan, does not complete TCP handshake.",
    ),
    (
      flag: "-T4",
      name: "Aggressive Timing",
      desc: "Faster scan timing template.",
    ),
  ),
  misconfigs: (
    (
      title: "Missing Firewall Rules",
      description: "Firewall not configured to block external scanning.",
    ),
  ),
)
```

## 3\. Code Block: `#code-block`

For standalone code snippets outside of a finding card.

### Usage

````typst
#code-block(
  title: "Python Reverse Shell",
  lang: "python",
  ```
import socket
import subprocess
# ... python shell code
  ```.text
)
````

## 4\. Inline Highlight: `#highlight`

To draw attention to specific, critical text inline with your prose.

### Usage

```typst
The database credentials were discovered: #highlight[user:password123].

Critical finding: #highlight(color: red)[Root SSH access enabled].
```
