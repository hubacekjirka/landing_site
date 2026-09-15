# 🌟 Landing Page - Powered by the Force


> *"In a galaxy far, far away... a developer's journey unfolds through the power of Warp and Codex"*

## 🚀 The Mission

This landing page chronicles the professional journey of a Jedi Developer, showcasing public information with the elegance of the Force and the precision of advanced AI assistance.

## ⚡ Powered by the Force

This project was crafted using the combined might of:

- **🌊 Warp** - The terminal that brings order to the command line chaos
- **🤖 Codex** - AI assistance that flows through every line of code
- **✨ The Force** - That mystical energy that binds the galaxy together... and makes great code

## 🎯 Features

- 📋 **Professional Information Display** - Your skills, experience, and achievements laid out with Imperial precision
- 🎨 **Responsive Design** - Adapts to all screen sizes like a protocol droid adapts to languages
- ⚡ **Lightning Fast** - Loads faster than the Millennium Falcon making the Kessel Run
- 🛡️ **Secure & Public** - Only public information displayed, following the Jedi Code of transparency

## 🎭 The Story Behind

Every line of code in this project was guided by:
- The wisdom of **Warp's** intuitive terminal experience
- The intelligence of **Codex** AI assistance
- The timeless principles of clean, maintainable code

*"Your focus determines your reality."* - Qui-Gon Jinn

And our focus was on creating a landing page worthy of the Jedi Archives.

## 🧱 Infrastructure & HTTPS

- Terraform provisions the S3 static website, CloudFront distribution, and an ACM certificate for `hubacek.xyz` and `www.hubacek.xyz`.
- After running `terraform apply`, grab the `acm_dns_validation_records` output and create matching CNAME entries in GoDaddy so the certificate can be issued.
- Once the certificate is validated, point your public DNS at the `cloudfront_domain_name` output:
  - Create a CNAME for `www` → CloudFront domain.
  - For the apex (`hubacek.xyz`), use an ALIAS/ANAME record if your registrar supports it, or forward the root to `www`.
- CloudFront redirects HTTP → HTTPS automatically and serves the static assets from the S3 bucket.
## 🤖 Working with Codex Agents

When proposing changes, Codex agents follow the Jedi way:

1. **Create a feature branch** - Never commit directly to `main`
2. **Use imperative commit messages** - e.g., "Add responsive navigation" or "Fix hero section alignment"
3. **Describe your changes** - Explain what you did and why in the commit body
4. **Include a Star Wars quote** - End each commit message with wisdom from the saga

### Example Commit Format

```
Add dark mode toggle to navigation

- Implement theme switcher in header
- Store user preference in localStorage
- Apply consistent styling across all pages

"Do. Or do not. There is no try." - Yoda
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with ❤️ and the Force**

*May your code compile and your bugs be few*

🌟 ⚔️ 🌟

</div>
