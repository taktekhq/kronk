# Notes for agents

Writing rules for this repo. No exceptions.

- Be extremely succinct. Readers get bored fast. Write for them.
- Never use em dashes.
- Don't explain. State.
- Details go in a separate linked doc, Wikipedia style. Readers click if they care.
- Keep money separate from parts. Parts docs say what is needed. The bill says what was paid.
- List parts generically first, then the exact item bought.
- The build log is a journal of steps. No lessons, morals, or advice.

Repo layout:

- `gate/`: config files that live on `kronk-gate`
- `docs/parts.md`: what you need, generic, with the exact item bought
- `docs/parts/*.md`: one page per part that has detailed specs
- `docs/bill.csv`: exactly what was paid
- `docs/gate-setup.md` and `docs/home-setup.md`: reproducible setup steps
- `docs/build-log.md`: dated journal, newest first
- `docs/architecture.md`: how the system fits together
