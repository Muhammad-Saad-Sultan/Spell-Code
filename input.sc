spell main {

    potion power = 75;
    potion limit = 50;
    magic isHigh;
    summon 1var;

    portal (power > limit) {
        cast "The spell energy is strong!";
        bind isHigh = true;
    } elseportal {
        cast "The spell energy is weak...";
        bind isHigh = false;
    }

    chant (power > 0) {
        cast "Casting energy reduction spell...";
        bind power = power - 10;
    }

    vanish isHigh;
    reveal 0;
    endspell;
}
