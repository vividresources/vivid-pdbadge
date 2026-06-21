(function () {
    const root = document.getElementById('badge-root');
    const wallet = document.getElementById('wallet-img');
    const photoWrap = document.getElementById('photo-wrap');
    const photo = document.getElementById('photo-img');
    const identity = document.querySelector('.identity');
    const rankText = document.getElementById('rank-text');
    const nameText = document.getElementById('name-text');
    const frame = document.querySelector('.badge-frame');

    const WALLET_EMPTY = 'assets/wallet-nophoto.png';
    const WALLET_PHOTO = 'assets/wallet-photo.png';

    function fitText() {
        const scale = (frame?.clientWidth || 580) / 580;
        const limits = {
            rankMax: 38 * scale,
            rankMin: 15 * scale,
            nameMax: 60 * scale,
            nameMin: 20 * scale,
            floor: 0.48,
        };

        rankText.style.fontSize = '';
        nameText.style.fontSize = '';

        const style = getComputedStyle(identity);
        const padX = parseFloat(style.paddingLeft) + parseFloat(style.paddingRight);
        const maxW = identity.clientWidth - padX - 4;
        let rankSize = limits.rankMax;
        let nameSize = limits.nameMax;

        rankText.style.fontSize = rankSize + 'px';
        nameText.style.fontSize = nameSize + 'px';

        for (let n = 0; n < 80; n++) {
            const tooWide = rankText.scrollWidth > maxW || nameText.scrollWidth > maxW;
            const tooTall = identity.scrollHeight > identity.clientHeight + 1;
            if (!tooWide && !tooTall) break;

            rankSize = Math.max(limits.rankMin, rankSize - 0.5);
            nameSize = Math.max(limits.nameMin, nameSize - 0.75);
            rankText.style.fontSize = rankSize + 'px';
            nameText.style.fontSize = nameSize + 'px';

            if (rankSize <= limits.rankMin && nameSize <= limits.nameMin) break;
        }
    }

    function open(data) {
        const name = [data.firstname, data.lastname].filter(Boolean).join(' ').trim();
        rankText.textContent = data.rank || '';
        nameText.textContent = name || 'Unknown Officer';

        photo.onload = null;
        photo.onerror = null;

        if (data.photoUrl) {
            wallet.src = WALLET_PHOTO;
            photo.src = data.photoUrl;
            photoWrap.classList.remove('hidden');
            photo.onerror = function () {
                photoWrap.classList.add('hidden');
                photo.src = '';
                wallet.src = WALLET_EMPTY;
            };
        } else {
            wallet.src = WALLET_EMPTY;
            photo.src = '';
            photoWrap.classList.add('hidden');
        }

        root.classList.remove('hidden', 'hiding');
        requestAnimationFrame(() => requestAnimationFrame(fitText));
    }

    function close() {
        root.classList.add('hiding');
        setTimeout(() => {
            if (!root.classList.contains('hiding')) return;
            root.classList.add('hidden');
            root.classList.remove('hiding');
        }, 250);
    }

    window.addEventListener('message', (e) => {
        const msg = e.data;
        if (!msg) return;
        if (msg.action === 'showBadge') open(msg.data);
        if (msg.action === 'hideBadge') close();
    });
})();
