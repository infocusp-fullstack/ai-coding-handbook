---
description: Security-focused code review
---

Perform a security review of:

$ARGUMENTS

## Security Review Checklist

### Input Validation
- [ ] All user inputs are validated
- [ ] Input types are checked
- [ ] Input lengths/sizes are limited
- [ ] Special characters are handled

### Injection Vulnerabilities
- [ ] No SQL injection (parameterized queries used)
- [ ] No NoSQL injection
- [ ] No command injection
- [ ] No LDAP injection
- [ ] No XPath injection

### Cross-Site Scripting (XSS)
- [ ] Output is properly encoded/escaped
- [ ] Content-Type headers are set correctly
- [ ] User content is sanitized before display

### Authentication
- [ ] Authentication is required where needed
- [ ] Credentials are not hardcoded
- [ ] Session management is secure
- [ ] Password requirements are enforced

### Authorization
- [ ] Access controls are in place
- [ ] Users can only access their own data
- [ ] Privilege escalation is prevented
- [ ] Role checks are performed

### Sensitive Data
- [ ] Secrets are not in code
- [ ] Sensitive data is encrypted at rest
- [ ] Sensitive data is encrypted in transit
- [ ] Logs don't contain sensitive data
- [ ] Error messages don't leak info

### CSRF Protection
- [ ] Anti-CSRF tokens used for state-changing requests
- [ ] SameSite cookie attribute set

### Security Headers
- [ ] Content-Security-Policy
- [ ] X-Content-Type-Options
- [ ] X-Frame-Options
- [ ] Strict-Transport-Security

## Output Format

For each vulnerability found:

### [Vulnerability Name]
- **Severity**: Critical / High / Medium / Low
- **Location**: File and line number
- **Description**: What the vulnerability is
- **Impact**: What could happen if exploited
- **Proof of Concept**: How it could be exploited (if safe to describe)
- **Remediation**: How to fix it
- **References**: OWASP, CWE, or other relevant links

## Summary

Provide an overall security assessment:
- Total issues by severity
- Most critical findings
- Recommended priority for fixes
