/* @(#)text.c	2.1.8.1 */
/*
 * text.c --- pseaudo text generator for use in DBGEN 2.0
 *
 * Defined Routines:
 *		dbg_text() -- select and translate a sentance form
 */

#ifdef TEST
#define DECLARER
#endif /* TEST */

#include "config.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif /* HAVE_STRINGS_H */

#include "dss.h"
#include "dsstypes.h"

/* 
 * txt_vp() -- 
 *		generate a verb phrase by
 *		1) selecting a verb phrase form
 *		2) parsing it to select parts of speech
 *		3) selecting appropriate words
 *		4) adding punctuation as required
 *
 *	Returns: length of generated phrase
 *	Called By: txt_sentence()
 *	Calls: pick_str() 
 */
static int
txt_vp(char *dest, int sd) 
{
	char syntax[MAX_GRAMMAR_LEN + 1],
		*cptr,
		*parse_target;
	distribution *src;
	int i,
		res = 0;

	
	pick_str(&vp, sd, &syntax[0]);
	parse_target = syntax;
	while ((cptr = strtok(parse_target, " ")) != NULL)
	{
		src = NULL;
		switch(*cptr)
		{
		case 'D':
			src = &adverbs;
			break;
		case 'V':
			src = &verbs;
			break;
		case 'X': 
			src = &auxillaries;
			break;
		}	/* end of POS switch statement */
		i = pick_str(src, sd, dest);
		i = strlen(DIST_MEMBER(src, i));
		dest += i;
		res += i;
		if (*(++cptr))	/* miscelaneous fillagree, like punctuation */
		{
			dest += 1;
			res += 1;
			*dest = *cptr;
		}
		*dest = ' ';
		dest++;
		res++;
		parse_target = NULL;
	}	/* end of while loop */

	return(res);
}

/* 
 * txt_np() -- 
 *		generate a noun phrase by
 *		1) selecting a noun phrase form
 *		2) parsing it to select parts of speech
 *		3) selecting appropriate words
 *		4) adding punctuation as required
 *
 *	Returns: length of generated phrase
 *	Called By: txt_sentence()
 *	Calls: pick_str(), 
 */
static int
txt_np(char *dest, int sd) 
{
	char syntax[MAX_GRAMMAR_LEN + 1],
		*cptr,
		*parse_target;
	distribution *src;
	int i,
		res = 0;

	
	pick_str(&np, sd, &syntax[0]);
	parse_target = syntax;
	while ((cptr = strtok(parse_target, " ")) != NULL)
	{
		src = NULL;
		switch(*cptr)
		{
		case 'A':
			src = &articles;
			break;
		case 'J':
			src = &adjectives;
			break;
		case 'D':
			src = &adverbs;
			break;
		case 'N': 
			src = &nouns;
			break;
		}	/* end of POS switch statement */
		i = pick_str(src, sd, dest);
		i = strlen(DIST_MEMBER(src, i));
		dest += i;
		res += i;
		if (*(++cptr))	/* miscelaneous fillagree, like punctuation */
		{
			*dest = *cptr;
			dest += 1;
			res += 1;
		}
		*dest = ' ';
		dest++;
		res++;
		parse_target = NULL;
	}	/* end of while loop */

	return(res);
}

/* 
 * txt_sentence() -- 
 *		generate a sentence by
 *		1) selecting a sentence form
 *		2) parsing it to select parts of speech or phrase types
 *		3) selecting appropriate words
 *		4) adding punctuation as required
 *
 *	Returns: length of generated sentence
 *	Called By: dbg_text()
 *	Calls: pick_str(), txt_np(), txt_vp() 
 */
static int
txt_sentence(char *dest, int sd) 
{
	char syntax[MAX_GRAMMAR_LEN + 1],
		*cptr;
	int i,
		res = 0,
		len = 0;

	
	pick_str(&grammar, sd, syntax);
	cptr = syntax;

next_token:	/* I hate goto's, but can't seem to have parent and child use strtok() */
	while (*cptr && *cptr == ' ')
		cptr++;
	if (*cptr == '\0')
		goto done;
	switch(*cptr)
		{
		case 'V':
			len = txt_vp(dest, sd);
			break;
		case 'N': 
			len = txt_np(dest, sd);
			break;
		case 'P':
			i = pick_str(&prepositions, sd, dest);
			len = strlen(DIST_MEMBER(&prepositions, i));
			strcpy((dest + len), " the ");
			len += 5;
			len += txt_np(dest + len, sd);
			break;
		case 'T':
			i = pick_str(&terminators, sd, --dest); /*terminators should abut previous word */
			len = strlen(DIST_MEMBER(&terminators, i));
			break;
		}	/* end of POS switch statement */
		dest += len;
		res += len;
		cptr++;
		if (*cptr && *cptr != ' ')	/* miscelaneous fillagree, like punctuation */
		{
			dest += 1;
			res += 1;
			*dest = *cptr;
		}
		goto next_token;
done:
	*dest = '\0';
	return(--res);
}

/*
 * dbg_text() -- 
 *		produce ELIZA-like text of random, bounded length, truncating the last 
 *		generated sentence as required
 */
int
dbg_text(char *tgt, int min, int max, int sd)
{
	long length = 0; 
	int wordlen = 0,
		needed,
		s_len;
	char sentence[MAX_SENT_LEN + 1];
	
	RANDOM(length, min, max, sd);

	while (wordlen < length)
	{
		s_len = txt_sentence(sentence, sd);
		if ( s_len < 0)
			INTERNAL_ERROR("Bad sentence formation");
		needed = length - wordlen;
		if (needed >= s_len + 1)	/* need the entire sentence */
		{
			strcpy(tgt, sentence);
			tgt += s_len;
			wordlen += s_len + 1;
			*(tgt++) = ' ';
		}
		else /* chop the new sentence off to match the length target */
		{
			sentence[needed] = '\0';
			strcpy(tgt, sentence);
			wordlen += needed;
			tgt += needed;
		}
	}
	*tgt = '\0';

	return(wordlen);
}

#ifdef TEST
tdef tdefs = { NULL };

int main()
{
	char prattle[401];
	
	read_dist (env_config (DIST_TAG, DIST_DFLT), "nouns", &nouns);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "verbs", &verbs);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "adjectives", &adjectives);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "adverbs", &adverbs);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "auxillaries", &auxillaries);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "terminators", &terminators);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "articles", &articles);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "prepositions", &prepositions);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "grammar", &grammar);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "np", &np);
	read_dist (env_config (DIST_TAG, DIST_DFLT), "vp", &vp);

	while (1)
	{
		dbg_text(&prattle[0], 300, 400, 0);
		printf("<%s>\n", prattle);
	}

	return(0);
}
#endif /* TEST */
